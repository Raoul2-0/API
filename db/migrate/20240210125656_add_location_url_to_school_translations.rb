class AddLocationUrlToSchoolTranslations < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        School.add_translation_fields!({ location_url: :string }, migrate_data: true)
      end

      dir.down do
        remove_column :school_translations, :location_url, :string
      end
    end
    remove_column :schools, :location_url, :string
  end
end
