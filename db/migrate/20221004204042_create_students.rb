class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      # t.string :badge_number
      # t.string :enrollment_date
      # t.string :first_enrollment_date
      t.string :primary_school

      #t.timestamps (the timestamp is in the user table)
    end
    #add_index :students, :badge_number
  end
end
