class RemoveEvaluationTypeFromEvaluations < ActiveRecord::Migration[6.1]
  def change
    remove_column :evaluations, :evaluation_type_id
  end
end
