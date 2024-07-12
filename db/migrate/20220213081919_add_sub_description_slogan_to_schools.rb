
class AddSubDescriptionSloganToSchools < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        School.create_translation_table!({
          sub_denomination: :text,
          admission_generality: :text,
          sub_description: :text,
          slogan: :text,
          history: :text
        }, {
          :migrate_data => true
        })
      end

      dir.down do
        School.drop_translation_table! :migrate_data => true
      end
    end
  end
end
