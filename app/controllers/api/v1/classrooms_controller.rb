class Api::V1::ClassroomsController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]
  before_action :set_current_cycle

    # POST /classrooms
    def create
      resource = @Resource.new(resource_params)
      if resource.can_be_assigned_to_local?(params[:local_id].to_i)
        resource = create_resource(resource, { returnResource: true }) 
        
        resource = @ResourceService.new(global_params).make_block(resource)
        render json: resource, status: :created
      else
        mesg = I18n.t('cannot_be_assigned_to_local', scope: "classroom.create")
        render json: {message: mesg, flag: Flag::WARMING}, status: :ok
      end
    end
  


  private

    # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:denomination,  :number_of_students, :description, :class_level_id, :local_id, :cycle_id, :specialty_id)
    end
end
