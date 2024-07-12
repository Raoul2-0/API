class CreateEvaluations < ActiveRecord::Migration[6.1]
  def change
    create_table :evaluations do |t|
      t.date :evaluation_date
      t.time :start_time, default: '00:00:00'
      t.time :end_time, default: '00:00:00'
      t.references :course, null: false, foreign_key: true
      t.references :evaluation_type, null: false, foreign_key: true
      t.references :local, foreign_key: true

      #t.timestamps in details
    end
  end
end
