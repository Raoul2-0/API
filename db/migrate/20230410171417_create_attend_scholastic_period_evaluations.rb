class CreateAttendScholasticPeriodEvaluations < ActiveRecord::Migration[6.1]
  def change
    create_table :attend_scholastic_period_evaluations do |t|
      t.references :attend_scholastic_period, null: false, foreign_key: true, index: { name: "index_attend_evals_on_att_sch_period_id" }
      t.references :evaluation, null: false, foreign_key: true
      t.float :mark
      #t.timestamps in details
    end
  end
end
