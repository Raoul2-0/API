class Api::V1::ConfigureActivitiesController <  Api::V1::BaseController
  before_action :set_configure_activity, only: [:show, :update, :destroy]
  skip_before_action :constantize_model_service, only: [:index, :create, :table_header, :argument, :show, :update]
  # GET /configure_activities/1 
  def show
    show_resource(@configure_activity)
  end
  
  # PATCH/PUT /configure_activities/1
  def update
    update_delete_resource(@configure_activity, Constant::RESOURCE_METHODS[:update], configure_activity_params)
  end

  # POST /configure_activities
  def create
    @configure_activity = ConfigureActivity.new(configure_activity_params)
    create_resource(@configure_activity)
    #render json: @configure_activity.extra_activity, each_serializer: ExtraActivitySerializer, status: :created
  end

  # DELETE /configure_activities/1
  def destroy
    update_delete_resource(@configure_activity, Constant::RESOURCE_METHODS[:delete])
    # , new_parameters = nil, renderAfterUpdateDelete=false
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_configure_activity
    @configure_activity = ConfigureActivity.find(params[:id])
  end

  def configure_activity_params
    params.permit(:denomination, :description, :extra_activity_id)
  end
end
