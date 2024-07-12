class Attend < ApplicationRecord
  include Monitorable
  acts_as :state # to add boolean variable, isEnable, to the table isEnable
  belongs_to :school
  belongs_to :student
  #resourcify

  delegate :user_id, to: :student, allow_nil: false

  has_many :attend_scholastic_periods
  has_many :scholastic_periods, through: :attend_scholastic_periods
  validates_presence_of :registration_number, :first_enrollment_date

  delegate :fullname, :birthdate, :address, :initials, :small_gender, :identification_number, :all_phones, :email, :gender, :complete_address, :complete_birthdate, :avatar_url, :disabled, to: :student, allow_nil: false  # from user (by student)

  scope :enable_attend, -> {where(isEnable: true)}
  
  
  # Role.all.pluck(:name)
  #.pluck(:school_id)
  # def enable_attend
  #   self.find_by(isEnable: true)
  # end
  
end
