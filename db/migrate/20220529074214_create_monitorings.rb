class CreateMonitorings < ActiveRecord::Migration[6.1]
  def change
    create_table :monitorings do |t|
      t.integer :status, :limit => 8
      t.datetime :start_date
      t.datetime :end_date

      
      t.references   :create_who, references: :user
      t.references   :update_who, references: :user
      #t.references   :delete_who, references: :user

      t.timestamps
    end
  end
end
