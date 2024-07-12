class Api::V1::EvaluationsController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]

  # POST /evaluations
  def create
    if params[:local_id]
      local_is_available?("create") ? super : local_not_available
    else
      super # if the local does not exist, the evaluation can be created and the local will be assigned later
    end
  end

  # PATCH/PUT /resources/1
  def update
    if params[:local_id] || params[:evaluation_date] || params[:start_time] || params[:end_time] # one of these parameters has to be updated the availability should be first checked
      local_is_available?("update") ? super : local_not_available
    else
      super # if the local does not exist, the evaluation can be updated
    end
  end
 
  private
    # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:denomination, :description, :evaluation_date, :course_id, :evaluation_type_id, :local_id, timing_attributes: [:start_time, :end_time])
    end

    # Check if the local in which to perform the evaluation is available
    def local_is_available?(method)
      case method
        when "create"
          evaluation_date = Date.parse(params[:evaluation_date])
          start_time = params[:start_time]
          end_time = params[:end_time]
        when "update" # this case has to be improved in case the local_id correspond to the local_id of the evaluation to update
          # @resource here is the evaluation to update
          evaluation_date = params[:evaluation_date] ? Date.parse(params[:evaluation_date]) : @resource[:evaluation_date]
          # start_time = params[:start_time] ? params[:start_time] : @resource[:start_time].strftime("%H:%M")
          # end_time = params[:end_time] ? params[:end_time] : @resource[:end_time].strftime("%H:%M")
          start_time = params[:start_time] ? params[:start_time] : @resource[:start_time]
          end_time = params[:end_time] ? params[:end_time] : @resource[:end_time]
      end
      local=get_resource_by_id(params[:local_id],"local")
      local.check_local_availability?(evaluation_date,start_time , end_time) 
    end

    # render a message when the local is not available
    def local_not_available
      mesg = I18n.t('cannot_be_assigned_to_local', scope: "evaluation")
      render json: {message: mesg, flag: Flag::WARMING}, status: :ok
    end
end