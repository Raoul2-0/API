class Api::V1::AttendScholasticPeriodsController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]
  #skip_before_action :constantize_model_service, only: [:index, :create, :table_header, :argument, :show, :update]

    # GET /attend_scholastic_periods
    # def index
    #   @elements = AttendScholasticPeriod.fetch_resources(params, current_school, current_user)
    #   table_service = AttendScholasticPeriodService.new(table_body_params)
    #   render json: table_service.create_table_body, status: :ok
    # end

    # def table_header(extra_params = {})
    #   table_service = AttendScholasticPeriodService.new(table_header_params)
    #   render json: table_service.create_header, status: :ok
    # end
  
    # GET /attend_scholastic_periods/1
    def show
      show_resource(@resource)
    end
  
  
    # **** create should be  done during Registration ******
    # POST /attend_scholastic_periods 
    # def create 
    #   resource = AttendScholasticPeriod.new(resource_params)
    #   resource = create_resource(resource, { returnResource: true }) 
      
    #   resource = AttendScholasticPeriodService.new(global_params).make_block(resource)
    #   render json: resource, status: :created
    # end
  
    # PATCH/PUT /attend_scholastic_periods/1
    def update
      resource = update_delete_resource(@resource, Constant::RESOURCE_METHODS[:update], resource_params, { returnResource: true }) if !performed?  
      render json: resource, status: :ok if !performed?
    end
  
    # DELETE /attend_scholastic_periods/1
    # def destroy
    #   update_delete_resource(@resource, Constant::RESOURCE_METHODS[:delete]) 
    # end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = AttendScholasticPeriod.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:id, :scholastic_period_id, :attend_id, :enrollment_date, :classroom_id)
    end
end
