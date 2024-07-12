class Api::V1::SolutionsController < Api::V1::TablesController
    before_action :set_resource, only: [:show, :update, :destroy]
    before_action :set_parent_model, only: [:index, :create]
  
    # binding.pry
  
  private
  
  # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:denomination, :description, :homework_id)  
    end
  end
  