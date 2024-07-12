class CreateAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :attachments do |t|
      t.string :category
      t.integer :file_id, :limit => 8
      t.string :filename
      t.string :url
      t.string :content_type

      t.timestamps
    end
  end
end
