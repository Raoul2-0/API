class AdditionalFieldsToSchools < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
         School.add_translation_fields! terms_condition: :text
         School.add_translation_fields! privacy_policy: :text
         School.add_translation_fields! protocol: :text
         School.add_translation_fields! cookies_policy: :text
         School.add_translation_fields! social: :text
      end

      dir.down do
        remove_column :pschool_translations, :terms_condition
        remove_column :pschool_translations, :privacy_policy
        remove_column :pschool_translations, :protocol
        remove_column :pschool_translations, :cookies_policy
        remove_column :pschool_translations, :social
      end
    end
  end
end
