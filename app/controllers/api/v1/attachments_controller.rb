class Api::V1::AttachmentsController < Api::V1::BaseController
  include Cleaning
  include AttachmentModule
  before_action :set_attachment, only: [:show, :update, :destroy]
  skip_before_action :constantize_model_service, only: [:index, :create, :table_header, :argument, :show, :update]

  # GET /attachments
  def index
    @attachments = current_school_id ? Contact.by_school([current_school_id, "attachments"]) : Attachment.all
    @attachments = @attachments.order_by_created_at("attachments").page(page).per(per_page)

    render json: filter_resources(@attachments)
  end

  # GET /attachments/1
  def show
    show_resource(@attachment)
  end

  # POST /attachments
  # def create
  #   @attachment = Attachment.new(attachment_params)

  #   if @attachment.save
  #     render json: @attachment, status: :created, location: api_v1_attachment_url(@attachment)
  #   else
  #     render json: @attachment.errors, status: :unprocessable_entity
  #   end
  # end

  # PATCH/PUT /attachments/1
  # def update
  #   if @attachment.update(attachment_params)
  #     render json: @attachment
  #   else
  #     render json: @attachment.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /attachments/1
  def destroy
    #file_id  =  @attachment[:file_id]
    attachment_to_delete = @attachment.files.find_by_id(params[:file_id])
    if attachment_to_delete
      attachment_to_delete.purge
      clean_storage
    end
    update_delete_resource(@attachment, Constant::RESOURCE_METHODS[:delete])
    #@attachment.destroy
  end
  #resource_name = params['resource'].camelize.constantize
  #@resource = resource_name.find_by_id(params['record_id'])
  

  #To test with insomnia
  def add_files
    # resource_name = params[:resource].camelize.constantize
    # @resource = resource_name.find_by_id(params[:record_id])
    #ActiveStorage::Attachment.all.each { |attachment| attachment.purge }
    #Attachment.delete_all
    #clean_storage
    data = JSON.parse(params['data'])
    #ALLOWED_CLASSES
    class_name = data['resource'].camelize
    
    # Check if the class name is in the whitelist
    resource_name = class_name.constantize #if ALLOWED_CLASSES.include?(class_name)
    
    @resource = resource_name.find_by_id(data['record_id'])
    authorize @resource, policy_class: AttachmentPolicy
      begin
        data['attachments'].each do |attachment|
          category = attachment[0]
          attachment[1].each do |filename|
            name = filename.split('.').first
            file_to_attach = params[name]
            add_single_attachment(@resource, category, file_to_attach)
          end
        end 
        #delete_old_attachment(@resource)
        mesg = I18n.t 'success', scope: "attachments.add_files"
        render json: {message: mesg, flag: Flag::SUCCESS}, status: :created
      rescue => ex 
        mesg = I18n.t 'error', scope: "attachments.add_files"
        render json: {message: mesg, error_message: ex, flag: Flag::ERROR}, status: :internal_server_error
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attachment_params
      params.require(:attachment).permit(:category, :file_id, :filename, :url, :content_type)
    end
end
