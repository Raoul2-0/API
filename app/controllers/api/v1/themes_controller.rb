class Api::V1::ThemesController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]
  skip_before_action :set_current_scholastic_period  # :set_current_school,

  private

    # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:denomination, colors: [:black,  :white, :primary, :secondary,:grey_variant_1, :black_variant_1, :primary_variant_1, :primary_variant_2, :primary_variant_3, :primary_variant_4, :primary_variant_5])
    end
end
