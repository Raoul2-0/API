class RemoveStartAndEndTimeFromEvaluations < ActiveRecord::Migration[6.1]
  def change
    remove_column :evaluations, :start_time, :time
    remove_column :evaluations, :end_time, :time
  end
end
