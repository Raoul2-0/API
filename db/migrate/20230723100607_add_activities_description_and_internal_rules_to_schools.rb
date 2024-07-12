class AddActivitiesDescriptionAndInternalRulesToSchools < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        School.add_translation_fields! activities_description: :text
        School.add_translation_fields! internal_rules: :text
      end

      dir.down do
        remove_column :school_translations, :activities_description
        remove_column :school_translations, :internal_rules
      end
    end
  end
end
