module StudentModule
  FILTERS = %w[]
  SORT_DEFAULT = ""
  TO_INCLUDES = []
  MODEL_NAME = 'student'
  DEFAULT_ARGUMENT = 'students' unless const_defined?(:DEFAULT_ARGUMENT)
  
  def save_student(resource, parameters, user = current_user, school_id = request.headers['X-school-id'], scholastic_period_id = (request.headers['X-scholastic-period-id']).to_i)
    student_attributes = parameters[:student_attributes]
    student = Student.create!(calculate_student_attributes(student_attributes))
    resource.update!({ userable_type: "Student", userable_id: student.id })
  
    attend_params = { 
      school_id: school_id, 
      student_id: student.id,
    }.merge(calculate_attend_attributes(parameters[:attend_attributes]))

    attend = Attend.create!(attend_params)
  
    attend_scholastic_period_params = { 
      scholastic_period_id: scholastic_period_id, 
      attend_id: attend.id,
    }.merge(calculate_attend_scholastic_period_attributes(parameters[:attend_scholastic_period_attributes]))

    attend_scholastic_period = AttendScholasticPeriod.create!(attend_scholastic_period_params)
    
    [ resource, student, attend, attend_scholastic_period ].each do |value|
      update_monitor(value, Constant::RESOURCE_METHODS[:create], { user: user, monitor_attributes: {} })
    end

    resource.create_permissions(school_id)
  end

  def calculate_student_attributes(attributes)
    return {} unless attributes

    {
      primary_school: attributes[:primary_school]
    }
  end

  def calculate_attend_attributes(attributes)
    return {} unless attributes

    {
      registration_number: attributes[:registration_number],
      first_enrollment_date: attributes[:first_enrollment_date],
    }
  end

  def calculate_attend_scholastic_period_attributes(attributes)
    return {} unless attributes

    {
      enrollment_date: attributes[:enrollment_date],
      classroom_id: attributes[:classroom_id],
    }
  end
end