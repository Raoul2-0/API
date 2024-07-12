class AddMissionVisionToSchool < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        School.add_translation_fields! mission: :text
        School.add_translation_fields! vision: :text
      end

      dir.down do
        remove_column :school_translations, :mission
        remove_column :school_translations, :vision
      end
    end
  end
end
