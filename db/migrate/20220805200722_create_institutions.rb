class CreateInstitutions < ActiveRecord::Migration[6.1]
  def change
    create_table :institutions do |t|
      t.integer :institutionalisable_id
      t.string :institutionalisable_type

      t.timestamps
    end
  end
end
