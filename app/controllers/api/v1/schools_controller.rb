class Api::V1::SchoolsController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy, :update_jsonb, :assign_theme]
  before_action :authenticate_user! , except: [:show, :index, :super_school]
  #before_action :school_authorization, only: [:categories, :specialties, :cycles, :class_levels, :super_school]
  skip_before_action :set_current_school, :set_current_scholastic_period, only: [:create]

  
  # def table_header(extra_params = {})
  #   table_service = SchoolService.new(table_header_params)
  #   render json: table_service.create_header
  # end

  # GET /schools  (user should be authorized)
  # def index
  #   @elements = School.fetch_resources(params, current_school, current_user)

  #   table_service = SchoolService.new(table_body_params)
  #   render json: table_service.create_table_body, status: :ok
  # end

  def categories
    @elements = SchoolCategory.fetch_resources(params, current_school, current_user)

    render json: @elements&.map! { |el| el.minimal_block } || [], status: :ok
  end

  def specialties
    @elements = Specialty.fetch_resources(params, current_school, current_user)

    render json: @elements&.map! { |el| el.minimal_block } || [], status: :ok
  end

  def cycles
    elements = Cycle.fetch_resources(params, current_school, current_user)

    render json: elements.map! { |el| el.minimal_block } || [], status: :ok
  end

  def class_levels
    elements = ClassLevel.fetch_resources(params, current_school, current_user)

    render json: elements&.map! { |el| el.minimal_block } || [], status: :ok
  end

  # GET /schools/1
  def show
    instance_of_school_authorization
    render json: @resource, scholastic_period_id: params[:scholastic_period_id]
  end

  # GET /super_school
  def super_school
    #school_authorization
    render json: School.super_school
  end

  # POST /schools
  # def create
  #   resource = School.new(resource_params)
  #   resource = create_resource(resource, { notInstitutionalisable: true, returnResource: true }) 
    
  #   resource = SchoolService.new(global_params).make_block(resource)
  #   render json: resource, status: :created
  # end

  # PATCH/PUT /schools/1
  # def update
  #   resource = update_delete_resource(@resource, Constant::RESOURCE_METHODS[:update], resource_params, { returnResource: true })
    
  #   resource = SchoolService.new(global_params).make_block(resource)
  #   render json: resource, status: :ok
  # end

  # # DELETE /schools/1
  # def destroy
  #   update_delete_resource(@resource, Constant::RESOURCE_METHODS[:delete])
  # end

  # PATCH/PUT  /schools/:id/update_jsonb
  def update_jsonb
    instance_of_school_authorization
    begin
      school_keys = JSON.parse(@resource.to_json).keys
      school_keys.delete('id')
      jsonbs_to_update = school_keys & params.keys  # e.g ["contacts", "social_media"]
      jsonbs_to_update.each do |jsonb_to_update|
        temp_object = params[jsonb_to_update]
        temp_object.keys.each { |key|  @resource[jsonb_to_update][key] = temp_object[key]}
      end
      @resource.save!
      mesg = I18n.t 'success', scope: "schools.update_jsonb"
      render json: {message: mesg, flag: Flag::SUCCESS}, status: :ok
    rescue => exception
      mesg = I18n.t 'error', scope: "schools.update_jsonb"
      render json: {message: mesg, flag: Flag::ERROR}, status: :internal_server_error
    end
  end

  # POST /schools/:id/assign_theme
  def assign_theme
    instance_of_school_authorization
    begin
      @theme = Theme.find(params[:theme_id])
      @resource.theme = @theme
      @resource.save!
      mesg = I18n.t 'success', scope: "schools.assign_theme" #, default: :default
      render json: { message:  mesg, flag: Flag::SUCCESS} #, status: :ok
    rescue => exception
      mesg = I18n.t 'error', scope: "schools.assign_theme" #, default: :default
      render json: { message:  mesg, flag: Flag::SUCCESS}, status: :ok 
    end
  end

  # DELETE /schools/id/remove_theme (This function is not active because a school school always a theme)
  # def remove_theme
  #   authorize @resource
  #   begin
  #     @theme = Theme.find(params[:theme_id])
  #     @resource.theme.delete(@theme)
  #     @resource.save!
  #     mesg = I18n.t 'success', scope: "schools.remove_theme" #, default: :default
  #     render json: { message:  mesg, flag: Flag::SUCCESS} #, status: :ok
  #   rescue => exception
  #     mesg = I18n.t 'error', scope: "schools.assign_theme" #, default: :default
  #     render json: { message:  mesg, flag: Flag::SUCCESS}, status: :ok
  #   end
  # end

  private
    
    def school_authorization
      authorize School unless skip_authorization
    end

    def instance_of_school_authorization
      authorize @resource unless skip_authorization
    end
    # Use callbacks to share common setup or constraints between actions.
    # def set_school
    #   @resource = School.find(params[:id])
    # end
    # Only allow a list of trusted parameters through.
    # def resource_params
    #   if params[:theme_id].blank?
    #     params[:theme_id] = Theme.first.id # The first theme is the default them for all schools
    #   end
    #   params.permit(:category_id, :root_id, :parent_id, :denomination, :identification_number,
    #                 :history, :mission, :vision, :sub_denomination, :admission_generality, :sub_description, 
    #                 :slogan, :theme_id, :terms_condition, :privacy_policy, :protocol, :cookies_policy, :social, 
    #                 :activities_description, :internal_rules, 
    #                 contacts_info: [:email, :secondary_email, :address, :registration_number, :telephone_1, :telephone_2, :whatApp_number, :mobile_phone],
    #                 social_media: [:facebook, :linkedIn, :twitter, :youtube, :instagram, :playStore, :appStore, :windowsStore])
    # end


    def resource_params
      params[:theme_id] ||= Theme.first.id

      permitted_params = params.permit(
        :id, :category_id, :root_id, :parent_id, :denomination, :identification_number,
        :history, :mission, :vision, :sub_denomination, :admission_generality, :sub_description, 
        :slogan, :theme_id, :terms_condition, :privacy_policy, :protocol, :cookies_policy, :social, 
        :activities_description, :internal_rules,:location_url,
        "contacts_info[email]", "contacts_info[secondary_email]","contacts_info[address]", "contacts_info[registration_number]",
        "contacts_info[telephone_1]", "contacts_info[telephone_2]", "contacts_info[whatApp_number]", "contacts_info[mobile_phone]",
        "social_media[facebook]", "social_media[linkedIn]", "social_media[twitter]", "social_media[youtube]", "social_media[instagram]",
        "social_media[playStore]", "social_media[appStore]", "social_media[windowsStore]"
      )
    
      # Reformat the permitted parameters 
      formatted_params = {
        id: permitted_params[:id],
        category_id: permitted_params[:category_id],
        root_id: permitted_params[:root_id],
        parent_id: permitted_params[:parent_id], 
        denomination: permitted_params[:denomination], 
        identification_number: permitted_params[:identification_number],
        history: permitted_params[:history],
        mission: permitted_params[:mission],
        vision: permitted_params[:vision],
        sub_denomination: permitted_params[:sub_denomination],
        admission_generality: permitted_params[:admission_generality],
        sub_description: permitted_params[:sub_description],
        slogan: permitted_params[:slogan],
        theme_id: permitted_params[:theme_id],
        terms_condition: permitted_params[:terms_condition],
        privacy_policy: permitted_params[:privacy_policy],
        protocol: permitted_params[:protocol], 
        cookies_policy: permitted_params[:cookies_policy], 
        social: permitted_params[:social], 
        activities_description: permitted_params[:activities_description],
        internal_rules: permitted_params[:internal_rules],
        location_url: permitted_params[:location_url]
      }.compact # .compact removes nil values from a hash 

      contacts_info = {
          email: permitted_params["contacts_info[email]"],
          secondary_email: permitted_params["contacts_info[secondary_email]"],
          address: permitted_params["contacts_info[address]"],
          registration_number: permitted_params["contacts_info[registration_number]"],
          telephone_1: permitted_params["contacts_info[telephone_1]"],
          telephone_2: permitted_params["contacts_info[telephone_2]"],
          whatApp_number: permitted_params["contacts_info[whatApp_number]"],
          mobile_phone: permitted_params["contacts_info[mobile_phone]"]
        }.compact
       
        formatted_params[:contacts_info] = contacts_info if contacts_info != {}
        social_media = {
          facebook: permitted_params["social_media[facebook]"],
          linkedIn: permitted_params["social_media[linkedIn]"],
          twitter: permitted_params["social_media[twitter]"],
          youtube: permitted_params["social_media[youtube]"],
          instagram: permitted_params["social_media[instagram]"],
          playStore: permitted_params["social_media[playStore]"],
          appStore: permitted_params["social_media[appStore]"],
          windowsStore: permitted_params["social_media[windowsStore]"]
        }.compact
        formatted_params[:social_media] = social_media if social_media != {}
        formatted_params
    end
    
    
end
   