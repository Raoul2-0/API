class Api::V1::MonitoringsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:create] # :index, :show,
  before_action :set_monitoring, only: [:show, :update, :destroy]

  # GET /monitorings
  def index
    @monitorings = set_resources("monitoring").order_by_created_at("monitorings")
    render json: organize_per_page(@monitorings)
  end

  # GET /monitorings/1
  def show
    show_resource(@monitoring)
  end

  # POST /monitorings
  # def create
  #   @monitoring = Monitoring.new(monitoring_params)
  #   create_resource(@monitoring)
  # end

  # PATCH/PUT /monitorings/1
  def update
    update_delete_resource(@monitoring, Constant::RESOURCE_METHODS[:update], monitoring_params)
  end

  # PATCH/PUT update_attributes_monitor_of_resources
  def update_attributes_monitor_of_resources
    class_name = params[:record_type]
    # Check if the class name is in the whitelist
    resource_name = class_name.constantize if ALLOWED_CLASSES.include?(class_name)
    wrong_ids = []
    params[:ids].each do |record_id|
      resource = resource_name.find_by_id(record_id)
      if resource.nil?
        wrong_ids.append(record_id) if !wrong_ids.include? record_id
      else
        update_delete_resource(resource.monitoring, Constant::RESOURCE_METHODS[:update], params[:monitoring_attributes].as_json, { notRenderAfterUpdateDelete: true })
      end
    end
    if wrong_ids.any?
      mesg = I18n.t('warming', scope: 'monitorings.update_attributes_monitor_of_resources', wrong_ids: wrong_ids)
      temp_response = { message: mesg, flag: Flag::SUCCESS}
    else
      mesg = I18n.t('success', scope: 'monitorings.update_attributes_monitor_of_resources')
      temp_response = { message: mesg, flag: Flag::WARMING}
    end
    render json: temp_response
  end

  # DELETE /monitorings/1
  # def destroy
  #   update_delete_resource(@monitoring, Constant::RESOURCE_METHODS[:delete])
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monitoring
      @monitoring = Monitoring.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def monitoring_params
      params.permit(:status, :start_date, :end_date)
    end
end
