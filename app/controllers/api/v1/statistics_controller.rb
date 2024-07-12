class Api::V1::StatisticsController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]

  private

    # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:icon, :denomination, :description, :foreground, :scholastic_period_id)
    end
end
