class Api::V1::HomeworksController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]
  before_action :set_parent_model, only: [:index, :create]

  # binding.pry

private

# Only allow a list of trusted parameters through.
  def resource_params
    params.permit(:denomination, :description, :due_date, :optional, :serve_id)  
  end
end
