class Api::V1::CollaboratorsController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]

  private
    # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:link, :denomination, :description)
    end
end
