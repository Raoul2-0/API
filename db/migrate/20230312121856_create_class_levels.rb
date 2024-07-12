class CreateClassLevels < ActiveRecord::Migration[6.1]
  def change
    create_table :class_levels do |t|

      # t.timestamps # already in details
    end
  end
end
