class Api::V1::DecodeConfigurationsController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]

  private

  # Only allow a list of trusted parameters through.
  def resource_params
    params.permit(:group_key, :common, :denomination, :description)
  end
end
