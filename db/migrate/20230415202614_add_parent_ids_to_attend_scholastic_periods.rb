class AddParentIdsToAttendScholasticPeriods < ActiveRecord::Migration[6.1]
  def change
    add_column :attend_scholastic_periods, :parent1_id, :integer # we should add null: false in production
    add_column :attend_scholastic_periods, :parent2_id, :integer
  end
end
