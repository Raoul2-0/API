class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :sex, :string
    add_column :users, :birthday, :jsonb, null: false, default: '{}'
    add_column :users, :phones, :jsonb, null: false, default: '{}'
    add_column :users, :address, :jsonb, null: false, default: '{}'
    add_column :users, :email_confirmed, :boolean, default: false
  end
end
