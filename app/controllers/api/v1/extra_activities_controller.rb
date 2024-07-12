class Api::V1::ExtraActivitiesController <  Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy, :add_student, :remove_student, :manage_office, :manage_events]
  before_action :validate_cooperative_activity_with_published_monitor, only: [:update, :create]

  
  def add_student
    position = resource_params[:position] ? resource_params[:position] : Constant::EXTRA_ACTIVITY_MEMBER_TYPE[:ordinary] # if the position is not mentioned, create an ordinary member
    president_exists?(@resource.id) if position == Constant::EXTRA_ACTIVITY_MEMBER_TYPE[:president]
    activity_student_params = {extra_activity_id: params[:id], attend_scholastic_period_id: resource_params[:attend_scholastic_period_id], position: position}
    @activity_student = ActivityStudent.new(activity_student_params)
    create_resource(@activity_student, { notInstitutionalisable: true, nested_denomination: nil, notRenderAfterCreation: true }) 
    show if !performed?
  end

  def remove_student
    activity_student = @resource.activity_students.find_by_attend_scholastic_period_id(resource_params[:attend_scholastic_period_id])
    update_delete_resource(activity_student, Constant::RESOURCE_METHODS[:delete])  
  end
  
  def manage_office 
    task = request.headers['task']
    case task
      when "add_office"
       position = params[:position]
      when "remove_office"
       position = EXTRA_ACTIVITY_MEMBER_TYPE[:ordinary]
      # else
      #  position = EXTRA_ACTIVITY_MEMBER_TYPE[:ordinary]
     end
     president_exists?(@resource.id) if position == Constant::EXTRA_ACTIVITY_MEMBER_TYPE[:president]
     activity_student = @resource.activity_students.find_by_attend_scholastic_period_id(resource_params[:attend_scholastic_period_id])
     if activity_student.nil?
      not_found
     else
      activity_student_params = {position: position}
      update_delete_resource(activity_student, Constant::RESOURCE_METHODS[:update], activity_student_params, { notRenderAfterUpdateDelete: true })
      show if !performed?
     end
  end

  # def manage_events
  #   task = request.headers['task']
  #   case task
  #     when "add_event"
  #       @resource.events  << @event_activity
  #       @resource.save!
       
  #     when "update_event"
       
  #     when "remove_event"
        
  #     when "show_event"
        
  #     else
       
  #    end
  # end
  
  private

  # check if there is not more than one cooperative when creating or updating a cooperative extra_activity
  def validate_cooperative_activity_with_published_monitor
    if params[:status].to_i == Status::PUBLISHED && params[:category] == Constant::TYPE_OF_EXTRA_ACTIVITY[:cooperative]
      cooperatives_with_published_status = ExtraActivity.joins(:monitoring).where(category: "cooperative", monitorings: { status: Status::PUBLISHED })
      if cooperatives_with_published_status.length > 0
        message = I18n.t('activerecord.errors.controllers.extra_activity.not_more_than_one_cooperative')
        error_message_with_flag(message, Flag::ERROR)
      end
    end
  end


  # check if the president if already created
  def president_exists?(extra_activity_id)
    if (filter_resources(ActivityStudent.where(extra_activity_id: extra_activity_id, position: Constant::EXTRA_ACTIVITY_MEMBER_TYPE[:president]))).length() < 1
      true
    else
      mesg = I18n.t('not_more_than_one_president', scope: "global")
      render json: {message: mesg, flag: Flag::WARMING}, status: :not_found
    end
  end


  # Only allow a list of trusted parameters through.  :our_meetings removed
  def resource_params
    params.permit(:category, :denomination, :description,  :position, :attend_scholastic_period_id, preferences: [:color], configure_activity_attributes: [:id, :denomination, :description])
  end
end
