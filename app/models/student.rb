class Student < ApplicationRecord
  include Monitorable
  include Userable
  #include Attendable
  include StudentModule
  
  has_many :attends
  has_many :schools, through: :attends

  #has_one :parent TO UNCOMENT
  #validates_presence_of :badge_number, :enrollment_date, :first_enrollment_date

  # TO UNCOMENT
  #delegate :fullname, :all_phones, :email, to: :parent, prefix: true, allow_nil: true
  
  def self.fetch_resources(params, parent_model, user)
    parameters = {
      parent_model: parent_model,
      to_includes: TO_INCLUDES,
      status: params[:status]
    }
    
    resources = set_resources(MODEL_NAME, parameters)
   
    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
    
    resources.reorder(sort)
  end

  def enableAttend
    active_attend = self.attends.enable_attend[0]
  end

#   def get_all_schools
#     School.where(id: self.attends.pluck(:school_id))
#   end
  # for serializer
  def current_school_id
    self.attends.first["school_id"]
  end
  
  # for serializer
  def current_scholastic_period_id
    self.attends.first.attend_scholastic_periods.first["scholastic_period_id"]
  end
  
  # current attend  
  def current_attend
    self.attends.find_by_school_id(self.current_school_id)  # query to optimize to avoid double access to db
  end
  # current attend_scholastic_period
  def current_attend_scholastic_period
    self.current_attend.attend_scholastic_periods.find_by_scholastic_period_id(self.current_scholastic_period_id) # query to optimize to avoid multiple access to db
  end

  
  def registration_number
    current_attend.registration_number
  end
  def first_enrollment_date
    current_attend.first_enrollment_date
  end

  def enrollment_date
    current_attend_scholastic_period.enrollment_date
  end

  def attend_isEnable
    current_attend.isEnable
  end
  
  def attend_scholastic_period_isEnable
    current_attend_scholastic_period.isEnable
  end

  def student_attributes # attributes used in the student serializer
    { 
      id: id, 
      primary_school: primary_school
     }
  end

  def attend_attributes # attributes used in the student serializer
    { 
      id: current_attend[:id],
      school_id: current_attend[:school_id],
      student_id: current_attend[:student_id],
      registration_number: registration_number,
      first_enrollment_date: first_enrollment_date,
      attend_isEnable: attend_isEnable
    }
  end

  def attend_scholastic_period_attributes # attributes used in the student serializer
    { 
      id: current_attend_scholastic_period[:id],
      scholastic_period_id: current_attend_scholastic_period[:scholastic_period_id],
      attend_id: current_attend_scholastic_period[:attend_id],
      enrollment_date: enrollment_date,
      attend_scholastic_period_isEnable: attend_scholastic_period_isEnable
    }
  end

  def user_attributes # attributes used in the student serializer
    if self.user.nil?
      # should not be the case. But it should be handled
      {}
    else
      default_user_attributes
    end 
  end
end
