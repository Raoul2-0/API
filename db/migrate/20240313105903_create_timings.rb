class CreateTimings < ActiveRecord::Migration[6.1]
  def change
    create_table :timings do |t|
      t.time :start_time
      t.time :end_time
      t.references :timeable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
