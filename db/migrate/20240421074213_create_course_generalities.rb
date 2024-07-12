class CreateCourseGeneralities < ActiveRecord::Migration[6.1]
    def change
      create_table :course_generalities do |t|
  
        t.timestamps
      end
    end
  end
  