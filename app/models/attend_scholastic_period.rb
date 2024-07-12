class AttendScholasticPeriod < ApplicationRecord
  include Monitorable
  include AttendScholasticPeriodModule
  acts_as :state # to add boolean variable, isEnable, to the table isEnable
  belongs_to :attend
  belongs_to :scholastic_period
  belongs_to :classroom

  # connect AttendScholasticPeriod with evaluation
  has_many :attend_scholastic_period_evaluations
  has_many :evaluations, through: :attend_scholastic_period_evaluations
  # end connection

  # connect AttendScholasticPeriod with submission
  has_many :submissions
  # end connection


  # connect AttendScholasticPeriod with parent
  belongs_to :parent1, class_name: 'Parent', optional: true
  belongs_to :parent2, class_name: 'Parent', optional: true
  # end connection

  delegate :denomination, :specialty_denomination_with_desc, :denomination_with_level, to: :classroom, allow_nil: false, prefix: true
  delegate :student_id, :school_id, :user_id, :registration_number, to: :attend, allow_nil: false
  delegate :fullname, :birthdate, :address, :initials, :small_gender, :identification_number, :all_phones, :email, :gender, :complete_address, :complete_birthdate, :avatar_url, :disabled, to: :attend, allow_nil: false

  # connection with extra_activities
  has_many :activity_students
  has_many :extra_activities, through: :activity_students

  scope :by_classroom, ->(classroom_id) { where(classroom_id: classroom_id)}
  scope :by_common, lambda { |term| 
    joins(attend: { student: [:user]}).where("lower(users.first_name) ILIKE :t OR lower(users.last_name) ILIKE :t", t: "%#{term}%")
  }

  scope :by_user, lambda { |sp_id, user_id| 
    joins(attend: { student: [:user]}).where(scholastic_period_id: sp_id, users: { id: user_id })
  }

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

    # to remove
  def parent_fullname
    fullname
  end

   # to remove
  def parent_all_phones
    all_phones
  end

  # to remove
  def parent_email
    email
  end

  # to remove
  def parent_small_gender(upcase = false)
    small_gender(upcase)
  end

  # to remove
  def parent_complete_address
    complete_address
  end

  def fees_status
    ['partly', 'paid', 'unpaid'][rand(3)]
  end

  def enrollment_status
    ['inactive', 'active', 'pending'][rand(3)]
  end

  def repeating
    [true, false][rand(2)]
  end

  def enrollment_date
    return '' if self['enrollment_date'].blank?

    I18n.l(self['enrollment_date'])
  end

end
