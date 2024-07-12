class Api::V1::ClassLevelsController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]
  before_action :set_current_cycle

  private

    # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:denomination, :description)
    end
end
