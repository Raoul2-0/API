class AddPasswordResetExpiryDateColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :password_reset_expiry_date, :datetime
  end
end
