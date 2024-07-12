class CreateClassrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :classrooms do |t|
      t.integer :number_of_students, default: 0

      # t.timestamps # already in the details table

      # connect classroom to class_level, local, cycle
      t.references :class_level, foreign_key: true
      t.references :local, foreign_key: true
      t.references :cycle, foreign_key: true
    end

    # connect classroom to a student in a scholastic_period
    add_column :attend_scholastic_periods, :classroom_id, :bigint
    add_foreign_key :attend_scholastic_periods, :classrooms
  end
end
