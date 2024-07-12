class Api::V1::GalleriesController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]

  private
    # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:denomination, :description, :cover_image_id)
    end
end
