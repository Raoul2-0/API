class Classroom < ApplicationRecord
  attr_accessor :number_of_students # virtual attribute that compute the number of students of a classroom
  include Monitorable
  acts_as :detail
  include ClassroomModule
  include Localizable

  belongs_to :local

  

  # connect classroom to class_level, local, cycle
  #belongs_to :class_level
  
  #belongs_to :cycle

  # connect classroom to a student in a scholastic_period
  has_many :attend_scholastic_periods

  has_many :courses

  scope :by_common, ->(term) { where("lower(detail_translations.denomination) ILIKE ?", "%#{term}%")}

  def self.fetch_resources(params, school, user)
    
    parameters = {
      current_school_id: school.id,
      to_includes: TO_INCLUDES,
      status: params[:status]
    }
    resources = set_resources(MODEL_NAME, parameters)
   
    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
    resources.reorder(sort)
  end

  def minimal_block
    default_minimal_block.merge({number_of_students: number_of_students})
  end

  def cycle
    Cycle.find(cycle_id)
  end

  def cycle_denomination
    cycle.denomination
  end

  def denomination_with_level
    "#{denomination} - #{class_level_denomination}"
  end

  def specialty
    return if specialty_id.nil? 

    Specialty.find(specialty_id)
  end

  def specialty_denomination_with_desc
    return '' if specialty.blank?

    specialty.denomination_description 
  end

  def class_level
    ClassLevel.find(class_level_id)
  end

  def class_level_denomination
    class_level ? class_level.denomination : ""
  end

  def can_be_assigned_to_local?(local_id) 
    number_of_students < Local.find(local_id).capacity  
  end

  def number_of_students # compute the number of students of a classroom
    students.length || 0
  end
   
  def students
    attend_scholastic_periods.by_published
  end

  def evaluations
    Evaluation.joins(course: :classroom).where("classrooms.id = ?", id)
  end
   
end
