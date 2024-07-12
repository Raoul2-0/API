class Api::V1::StudentsController < Api::V1::TablesController
  before_action :set_student, only: [:show, :update, :destroy]
  #skip_before_action :constantize_model_service, only: [:index, :create, :table_header, :argument, :show, :update]

  # GET /students
  # def index
  #   @elements = Rails.cache.fetch('serves', expires_in: 1.minutes) do
  #     @students = set_resources("student", [:user, attends: [attend_scholastic_periods: [scholastic_period: [detail: :translations]]]])
  #     @students.by_scholastic_period([current_school_id, current_scholastic_period_id])
  #   end
  #   #@students = set_resources("student", [:user, attends: [attend_scholastic_periods: [scholastic_period: [detail: :translations]]]])
  #   #@elements = @students.by_scholastic_period([current_school_id, current_scholastic_period_id])
 
  #   table_service = StudentService.new(table_body_params)
  #   render json: table_service.create_table_body
  # end

  def table_header(extra_params = {})
    table_service = StudentService.new(table_header_params)
    render json: table_service.create_header
  end
  
  # GET /students/1
  def show
    show_resource(@student)
  end

  # PATCH/PUT /students/1
  def update
    if student_params[:user_attributes]
      update_delete_resource(@student.user, Constant::RESOURCE_METHODS[:update], student_params[:user_attributes], { renderAfterDelete: false }) if !performed?
    end
    if current_school_id
      @attend = @student.attends.find_by_school_id(current_school_id)
      if student_params[:attend_attributes]
        update_delete_resource(@attend, Constant::RESOURCE_METHODS[:update], student_params[:attend_attributes], { renderAfterDelete: false }) if !performed?
      end
      
      
      if current_scholastic_period_id
        @attend_scholastic_period = @attend.attend_scholastic_periods.find_by_scholastic_period_id(current_scholastic_period_id)
        if student_params[:attend_scholastic_period_attributes]
          update_delete_resource(@attend_scholastic_period, Constant::RESOURCE_METHODS[:update], student_params[:attend_scholastic_period_attributes],renderAfterDelete=false) if !performed?
        end
      end 
    end
    # student attributes is saved at the end to enable rendering
    if student_params[:student_attributes]
      update_delete_resource(@student, Constant::RESOURCE_METHODS[:update], student_params[:student_attributes],renderAfterDelete=false) if !performed?
    end
    # last render in case student_attributes 
    show_resource(@student) if !performed? 
  end

  # DELETE /students/1
  def destroy
    update_delete_resource(@student, Constant::RESOURCE_METHODS[:delete])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end
    
    # Only allow a list of trusted parameters through.
    def student_params
      params.permit(student_attributes: [:primary_school], attend_attributes: [:registration_number, :first_enrollment_date, :isEnable] , attend_scholastic_period_attributes: [:enrollment_date, :isEnable,:classroom_id, :parent1_id, :parent2_id],
      user_attributes: [:first_name, :last_name, :sex, :email, :identification_number, :is_admin, birthday: [:date, :country, :city], phones: [:phone_1, :phone_2, :landline], address: [:country, :region, :city, :street, :po_box], preferences: [:school_id]])
    end
end
