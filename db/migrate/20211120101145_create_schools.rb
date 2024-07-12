class CreateSchools < ActiveRecord::Migration[6.1]
  def change
    create_table :schools do |t|
      t.integer :root_id, :limit => 8
      t.integer :parent_id, :limit => 8
      t.string :denomination
      t.jsonb :contacts_info, null: false, default: '{}'
      t.jsonb :social_media,  null: false, default: '{}'

      t.timestamps
    end
  end
end
