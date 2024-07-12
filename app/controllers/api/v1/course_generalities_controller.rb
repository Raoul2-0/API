class Api::V1::CourseGeneralitiesController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]

      # binding.pry

  private

    # Only allow a list of trusted parameters through.
    def resource_params
       params.permit(:denomination, :description, :duration)  
      # params.require(:course_generality).permit(:description, :denomination, :school_id, :scholastic_period_id)
    end
end
