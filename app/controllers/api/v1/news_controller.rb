class Api::V1::NewsController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]
  
  private

    # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:foreground, :sidebar, :publication_date, :denomination, :sub_denomination, :description)
    end
end
