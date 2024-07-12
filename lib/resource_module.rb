
module ResourceModule
  #include AttachmentModule
  include Utils

  # show a resource if not deleted 
  def show_resource(resource,options=nil)
    #to_rend =  !render_deleted_resource(resource) ? resource : nil

    if resource.blank? || is_deleted?(resource)
      #render json: nil
      render_deleted_resource(resource)
    else
      render_resource_with_options(resource, :ok, options)
    end
  end
  

  
  # create the institution associated with a resource
  def create_institutions(resource, school=current_school)
    @institution = school.institutions.create(institutionalisable: resource)
  end

  # create and monitor a resource
  def create_resource(resource, create_options = {})
    institutionalisable = !(create_options[:notInstitutionalisable] || false) 
    nested_denomination = create_options[:nested_denomination] || nil 
    renderAfterCreation = !(create_options[:notRenderAfterCreation] || false)
    options = create_options[:options] || nil
    user    = create_options[:user]    || current_user 
    school  = create_options[:school]  || current_school
    returnResource = create_options[:returnResource] || false

    #current_user = user if current_user.nil?
    
    create_institutions(resource, school) if institutionalisable
    #authorize  resource if   (defined?(current_user)).nil?
    begin
      resource.save_and_check_creation_in_default_locale
      resource.build_decodes(params, @Resource::DECODE_LIST) if @Resource.const_defined?(:DECODE_LIST)
      
      # Add attachments if exist
      attachments = params["attachments"] if defined?(params)
       if attachments
         school = resource if controller_name == "schools"
        add_attachments(resource, attachments, school)
       end
      # monitor who is creating the resource
      
      update_monitor(resource, Constant::RESOURCE_METHODS[:create], { user: user, nested_denomination: nested_denomination }) 
      resource.create_resource_cache_key # cache the resource after creation
      return resource if returnResource
      
      if renderAfterCreation
        #render json: resource, status: :created #, location: location
        render_resource_with_options(resource, :created, options)
      end
    rescue => exception
      # destroy the resource and the potential attachments/monitor if already created
      if resource.created_at.present?
        attachments = resource.attachments
        resource.attachments.destroy_all  if attachments
        monitor = resource.monitoring
        if monitor
          monitor.destroy if monitor.created_at.present?
        end
        if institutionalisable 
          institutions = school.institutions
          school.institutions.where(institutionalisable_type: resource.model_name.human, institutionalisable_id: resource.id).destroy_all if institutions
        end
        
        resource.destroy
      end
      # Remove the monitor if already set
      render json: exception, status: :internal_server_error
    end
  end
  
  # update or delete any resource
  def update_delete_resource(resource, method, new_parameters = nil, update_delete_options = {})
    renderAfterUpdateDelete = !(update_delete_options[:notRenderAfterUpdateDelete] || false)
    nested_denomination = update_delete_options[:nested_denomination] || nil
    options = update_delete_options[:options] || nil
    returnResource = update_delete_options[:returnResource] || false
    school  = update_delete_options[:school]  || current_school

    if resource
      model_name = resource.model_name.plural
      resource_name = resource.model_name.name
      singular_model_name = resource.model_name
      #authorize resource if current_user
      #scope = model_name + "." + method
      scope = "resource" + "." + method
      begin
        if !render_deleted_resource(resource)
          if method.eql?(Constant::RESOURCE_METHODS[:update])
            
            resource.update!(new_parameters) # update the resource
            resource.build_decodes(params, @Resource::DECODE_LIST) if @Resource.const_defined?(:DECODE_LIST)

            attachments = params["attachments"]

            add_attachments(resource, attachments, school) if attachments # add attachments if exist
            
            if model_name != "monitorings"
              update_monitor(resource, method) # monitor who is updating the resource
              resource.reload
            end

            return resource if returnResource
        
            if renderAfterUpdateDelete
              #render json: resource, status: :ok
              render_resource_with_options(resource, :ok, options)
            end
          end

          if method.eql?(Constant::RESOURCE_METHODS[:delete])
            # resource.destroy! # any resource should not be permanently destroyed
            update_monitor(resource, method, {nested_denomination: nested_denomination })  # monitor who is deleting the resource
            resource.reload
            resource.cancel_resource_cache_key # cancel the cache key of the resource after deletion
            if renderAfterUpdateDelete
              mesg = I18n.t('success', scope: scope, resource_name: resource_name.camelize)
              render json: {message: mesg, flag: Flag::SUCCESS}, status: :ok
            end
          end  

        end 
      rescue => exception
        #mesg = resource_name.nil? ? I18n.t('error', scope: scope, resource_name: resource_name) : mesg = I18n.t('error', scope: "global")
        render json: {message: exception, flag: Flag::ERROR}, status: :internal_server_error
      end
    else
      not_found_resource_warming
    end
  end

  # render resource
  def render_resource_with_options(resource,mode, options=nil)
    if options.nil?
      render json: resource, status: mode
    else
      render json: resource, scope: options, status: mode
    end
  end
  # renders a undefined or deleted resource
  def render_deleted_resource(resource)
    if resource.nil? # the resource does not exist and have never been created
      mesg = I18n.t 'resource_not_found:', scope: 'global'
      render json: {
        message: mesg,
        flag: Flag::WARMING
      }, status: 404 
    elsif params[:restore].blank? && is_deleted?(resource) # the resource have been logically deleted
      mesg = I18n.t 'deleted_resource', resource_name: resource.model_name, scope: 'global'
      render json: {
        message: mesg,
        flag: Flag::WARMING
      }, status: 404
    else
       false
    end
  end

  # DELETE /destroys
  def destroys
    delete_resources
  end

  # The following methods are included in the base controller and visible by all controllers and sub-controller inheretit the base controller
  # GET /resources
  def index
    authorize  @Resource unless skip_authorization  # @Resource,
    # binding.pry
    @elements = @Resource.fetch_resources(params, @parent_model, current_user)
    table_service = @ResourceService.new(table_body_params.merge({minimal: params[:minimal].present?}))
    to_render = table_service.create_table_body

    if ["extra_activities"].include?(controller_name)
      if @data_type == 'original'
        render json: to_render, scope: {current_school_id: current_school_id}, status: :ok if !performed?
      elsif !performed?
        render json: to_render, status: :ok
      end
    elsif !performed?
      render json: to_render, status: :ok
    end
  end

  def table_header(extra_params = {})
    table_service = @ResourceService.new(table_header_params)
    render json: table_service.create_header, status: :ok
  end
  
  # GET /resources/1
  def show
    check_authorize(@resource) 
    if ["extra_activities"].include?(controller_name)
      show_resource(@resource,options={current_school_id: current_school_id})
    else
      show_resource(@resource)
    end
  end

  # POST /resources
  def create
    authorize @Resource unless skip_authorization
    if ["events", "schools", "themes", "homeworks","solutions","submissions","courses"].include?(controller_name)
      case controller_name
      when "events"
        resource = @Resource.new(eventable: @parent_model)
        
        resource.attributes = resource_params
        resource = create_resource(resource, { nested_denomination: "phase", returnResource: true })
      when "homeworks"
        resource = @Resource.new(homeworkable: @parent_model)
        resource.attributes = resource_params
        resource = create_resource(resource, { notInstitutionalisable: true, returnResource: true })
      when "solutions"
        resource = @Resource.new(resource_params)
        resource = create_resource(resource, { notInstitutionalisable: true, returnResource: true })
      when "submissions"
        resource = @Resource.new(resource_params)
        resource = create_resource(resource, { notInstitutionalisable: true, returnResource: true })
      when "courses"
        resource = @Resource.new(resource_params)
        resource = create_resource(resource, { notInstitutionalisable: true, returnResource: true })
      when "schools", "themes"
          resource = @Resource.new(resource_params)
        resource = create_resource(resource, { notInstitutionalisable: true, returnResource: true })
      else
        # to be defined
      end
     
    else
      resource = @Resource.new(resource_params)
      if controller_name == "evaluations"
        resource = create_resource(resource, { nested_denomination: "timing", returnResource: true })
      else
        binding.pry
        resource = create_resource(resource, { returnResource: true })
      end
    end
    resource = @ResourceService.new(global_params).make_block(resource)
    render json: resource, status: :created if !performed?
  end


  # PATCH/PUT /resources/1
  def update
    
      check_authorize(@resource)
      resource = update_delete_resource(@resource, Constant::RESOURCE_METHODS[:update], resource_params, { returnResource: true })
      resource = @ResourceService.new(global_params).make_block(resource) unless ["contacts", "monitorings"].include?(controller_name) # for controllers that do not have services
      render json: resource, status: :ok if !performed?
  rescue => exception
      mesg = I18n.t 'general:error'
      render json: {message: mesg, error_message: exception.message, flag: Flag::ERROR}, status: :internal_server_error if !performed?
    
  end

  # DELETE /resource/1
  def destroy
    check_authorize(@resource)
    update_delete_resource(@resource, Constant::RESOURCE_METHODS[:delete]) 
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_resource # used in all controller that inherits base_controller
    @resource = get_resource_by_id(params[:id],controller_name.singularize)
    case controller_name
      when 'students'
        # to do
      when 'serves'
        # to do
      when 'parents'
        @user = @resource.user
      else
        # Code block for all other values
    end
  end

  # check if a resource is different from nil before authorize
  def check_authorize(resource)
    if resource.nil?
      not_found_resource_warming
    else
      authorize resource unless skip_authorization
    end
  end
  
  def not_found_resource_warming 
    resource_name = controller_name.singularize
    mesg = I18n.t('unknown', scope: "resource", resource_name: resource_name.camelize)
    render json: {message: mesg, flag: Flag::WARMING}, status: :not_found if !performed?
  end
  # end base controller methods
end
