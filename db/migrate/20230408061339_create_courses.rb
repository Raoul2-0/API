class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|

      #t.timestamps # already in details
      t.references :classroom, foreign_key: true
    end
  end
end
