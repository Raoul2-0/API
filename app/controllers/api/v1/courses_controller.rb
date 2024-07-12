class Api::V1::CoursesController < Api::V1::TablesController
  before_action :set_resource, only: [:show, :update, :destroy]
  before_action :set_course, only: [:add_teacher, :remove_teacher, :teachers, :set_main_teacher, :remove_main_teacher]
  before_action :set_parent_model, only: [:index, :create]
  def add_teacher
    begin
      teacher = Serve.find_by(id: params[:serve_id])
      if teacher #&& eligible_teacher_profiles.include?(teacher.profile_id)
        unless @course.serves.include?(teacher)
          @course.serves << teacher
          render json: { message: I18n.t('courses.add_teacher.success'), flag: Flag::SUCCESS }
        else
          render json: { message: I18n.t('courses.add_teacher.already_added'), flag: Flag::SUCCESS }, status: :ok
        end
      else
        render json: { message: I18n.t('courses.add_teacher.invalid'), flag: Flag::ERROR }, status: :unprocessable_entity
      end
    rescue => exception
      render json: { message: I18n.t('courses.add_teacher.error'), flag: Flag::ERROR }, status: :internal_server_error
    end
  end

  # DELETE /courses/:id/remove_teacher
  def remove_teacher
    begin
      teacher = @course.serves.find_by(id: params[:serve_id])
      if teacher
        # @course.serves.delete(teacher)
        monitor = teacher.monitoring
        monitor.status = Status::DELETED
        monitor.save!
        render json: { message: I18n.t('courses.remove_teacher.success'), flag: Flag::SUCCESS }
      else
        render json: { message: I18n.t('courses.remove_teacher.not_found'), flag: Flag::ERROR }, status: :not_found
      end
    rescue => exception
      render json: { message: I18n.t('courses.remove_teacher.error'), flag: Flag::ERROR }, status: :internal_server_error
    end
  end

  # GET /courses/:id/teachers
  def teachers
    teachers = @course.serves#.where(profile_id: eligible_teacher_profiles)
    render json: teachers, status: :ok
  end

 # PATCH /courses/:id/set_main_teacher
  def set_main_teacher
    begin
      teacher = @course.serves.find_by(id: params[:serve_id])
      if teacher #&& eligible_teacher_profiles.include?(teacher.profile_id)
        new_main_teacher = @course.course_serves.find_by(serve_id: teacher.id)
        if !new_main_teacher.is_main_teacher?
          # Remove current main teacher if there is one
          current_main_teacher = @course.course_serves.find_by(is_main_teacher: true)
          if current_main_teacher.present?
            current_main_teacher.is_main_teacher = false
            current_main_teacher.save! 
          end
          # Set the new main teacher
          @course.course_serves.find_by(serve_id: new_main_teacher.serve_id).update(is_main_teacher: true)

          render json: { message: I18n.t('courses.main_teacher.success'), flag: Flag::SUCCESS }
        else
          render json: { message: I18n.t('courses.main_teacher.success'), flag: Flag::SUCCESS }
        end
      else
        render json: { message: I18n.t('courses.main_teacher.invalid'), flag: Flag::ERROR }, status: :unprocessable_entity
      end
    rescue => exception
      render json: { message: I18n.t('courses.main_teacher.error'), flag: Flag::ERROR }, status: :internal_server_error
    end
  end

  # PATCH /courses/:id/remove_main_teacher
  def remove_main_teacher
    begin
      main_teacher = @course.course_serves.find_by(is_main_teacher: true)
      if main_teacher
        main_teacher.is_main_teacher = false
        main_teacher.save!
        render json: { message: I18n.t('courses.main_teacher.success'), flag: Flag::SUCCESS }
      else
        render json: { message: I18n.t('courses.main_teacher.not_found_or_not_main'), flag: Flag::ERROR }, status: :not_found
      end
    rescue => exception
      render json: { message: I18n.t('courses.main_teacher.error'), flag: Flag::ERROR }, status: :internal_server_error
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def resource_params
      params.permit(:code, :subject, :denomination, :description, :coefficient, :classroom_id, :scholastic_period_id, :course_generality_id)
    end

    def set_course
      @course = Course.find(params[:id])
    end

    def eligible_teacher_profiles
      profiles = self.current_school.profiles
      teacher_profiles = profiles.select do |profile|
        ["Regular teacher", "Temporary teacher", "Trainee teacher"].include?(profile.denomination)
      end
      teacher_profile_ids = teacher_profiles.map(&:id)
      teacher_profile_ids
    end    
end
