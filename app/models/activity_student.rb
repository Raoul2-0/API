class ActivityStudent < ApplicationRecord
  include Monitorable

  # connect attend_scholastic_period with extra_activity
  belongs_to :attend_scholastic_period
  belongs_to :extra_activity

  validates_uniqueness_of :attend_scholastic_period_id, :scope => [:extra_activity_id] # a student cannot be added more than one time in an extra activity
end
