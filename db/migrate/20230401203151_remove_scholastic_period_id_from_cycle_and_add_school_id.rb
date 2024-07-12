class RemoveScholasticPeriodIdFromCycleAndAddSchoolId < ActiveRecord::Migration[6.1]
  def change
    remove_column :cycles, :scholastic_period_id
    #add_foreign_key :cycles, :schools
  end
end
