class ConfigureActivity < ApplicationRecord
  #include ConfigureActivityModule
  belongs_to :extra_activity
  acts_as :detail
  include Monitorable
  include Attachable

  # define  scope
  scope :by_denomination, lambda { |denomination| where(denomination: denomination)}
  scope :by_extra_activity_id, lambda { |extra_activity_id| where(extra_activity_id: extra_activity_id)}
  #validates_sence_of :denomination
  #validates_uniqueness_of :denomination
  #scope :by_denomination, lambda { |denomination| find_by(denomination: denomination)}
end
