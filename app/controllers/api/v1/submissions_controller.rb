class Api::V1::SubmissionsController < Api::V1::TablesController
    before_action :set_resource, only: [:show, :update, :destroy]
  
    private
  
      # Only allow a list of trusted parameters through.
      def resource_params
      
        params.permit(:denomination, :description, :teacher_comment, :correctness, :attend_scholastic_period_id, :homework_id)
      
      end
  end
  