class CreateActivityStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :activity_students do |t|
      t.belongs_to :extra_activity
      t.belongs_to :attend_scholastic_period
      t.string :position

      t.timestamps
    end
  end
end
