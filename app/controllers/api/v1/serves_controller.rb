class Api::V1::ServesController < Api::V1::TablesController
  #before_action :set_resource, only: [:set_serve]
  before_action :set_serve, only: [:show, :update, :destroy]
  #skip_before_action :constantize_model_service, only: [:index, :create, :table_header, :argument, :show, :update]
  

  # GET /Serves
  # def index
  #   #@elements = Serve.fetch_resources(params, current_school, current_user)
  #   #@elements = Rails.cache.fetch(controller_name) do
  #   @elements = Serve.fetch_resources(params, current_school, current_user)   #).to_a
  #   binding.pry
  #   table_serve = ServeService.new(table_body_params.merge({minimal: params[:minimal].present?}))
  #   render json: table_serve.create_table_body
  # end

  # def table_header(extra_params = {})
  #   table_serve = ServeService.new(table_header_params)
  #   render json: table_serve.create_header
  # end
  
  # GET /Serves/1
  # def show
  #   show_resource(@resource)
  # end

  # PATCH/PUT /Serves/1

  def serves_data
    @Resource = Serve
    authorize :index, @Resource unless skip_authorization 
    @elements = @Resource.fetch_resources(params, current_school, current_user)
    service_params = global_params.merge({elements: @elements})
    table_service = ServeService.new(service_params)
    to_render = table_service.organize_by_profile

    render json: to_render, status: :ok
  end

  def update
    if params[:user_attributes]
      update_delete_resource(@user, Constant::RESOURCE_METHODS[:update], user_params, { notRenderAfterUpdateDelete: true }) if !performed?
    end

    if params[:staff_attributes]
      update_delete_resource(@staff, Constant::RESOURCE_METHODS[:update], staff_params, { notRenderAfterUpdateDelete: true }) if !performed?
    end

    resource = update_delete_resource(@resource, Constant::RESOURCE_METHODS[:update], serve_params, { returnResource: true , notRenderAfterUpdateDelete: true})  if !performed?
    resource = ServeService.new(global_params).make_block(resource)
    render json: resource, status: :ok if !performed?
  end

  # DELETE /Serves/1
  def destroy
    update_delete_resource(@resource, Constant::RESOURCE_METHODS[:delete])
  end
  
  # POST id:/create_permissions

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_serve
      set_resource # defined in the base controller
      @staff = @resource.staff if @resource 
      @user = @staff.user if @staff
    end
    
    # 
    # Only allow a list of trusted parameters through.
    def serve_params
      params.permit(:id, :school_id, :staff_id, :job_id, :profile_id, :departement_id, :first_serving_date, :is_school_admin, :isEnable)
    end

    def staff_params
      params.require(:staff_attributes).permit(:signature, infos: [:link_curiculum, :compagny_name, :compagny_adress, :compagny_email, :compagny_phone, :personal_website])
    end

    def user_params
      params.require(:user_attributes).permit(
        :first_name, :last_name, :sex, :email, :identification_number, :is_admin, birthday: [:date, :country, :city], phones: [:phone_1, :phone_2, :landline], address: [:country, :region, :city, :street, :po_box], preferences: [:school_id])
    end
end
