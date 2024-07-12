class Api::V1::TableDescriptionsController < Api::V1::BaseController
  include ResourceModule
  before_action :set_table_description, only: [:show, :update, :destroy]
  skip_before_action :constantize_model_service, only: [:index, :create, :table_header, :argument, :show, :update]

  # GET /table_descriptions
  def index
    @table_descriptions = TableDescription.order(:category).page(params[:page]).per(per_page)
    render json: @table_descriptions
  end

  # GET /table_descriptions/1
  def show
    render json: @table_description
  end

  # POST /table_descriptions
  def create
    @table_description = TableDescription.new(table_description_params)
    create_resource(@table_description)
  end

  # PATCH/PUT /table_descriptions/1
  def update
    update_delete_resource(@table_description, Constant::RESOURCE_METHODS[:update], table_description_params)
  end

  # DELETE /table_descriptions/1
  def destroy
    update_delete_resource(@table_description, Constant::RESOURCE_METHODS[:delete])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_table_description
      @table_description = TableDescription.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def table_description_params
      params.require(:table_description).permit(:category, :description)
    end
end
