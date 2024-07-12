class Api::V1::ContactsController < Api::V1::BaseController
  #skip_before_action :constantize_model_service, only: [:index, :create, :table_header, :argument, :show, :update] 
  skip_before_action :authenticate_user!, only: [:create] # :index, :show,
  #before_action :set_contact, only: [:show, :update, :destroy]
  before_action :set_resource, only: [:show, :update, :destroy]

  # GET /contacts
  def index
    @contacts = @Resource.fetch_resources(params, @parent_model, current_user) 
    render json: organize_per_page(@contacts)
  end



  # POST /contacts
  def create
    @contact = Contact.new(resource_params)
    create_resource(@contact)
  end


  # DELETE /contacts/1
  # def destroy
  #   update_delete_resource(@contact, Constant::RESOURCE_METHODS[:delete])
  # end
  


  private

    # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:first_name, :last_name, :email, :phone_number, :message, :readed)
    end
end
