class Api::V1::ParametersConfigsController < Api::V1::BaseController

  def index
    @parameters_config = ParametersConfig.by_school(current_school.ancestries_ids)

    render json: @parameters_config, status: :ok
  end
end