class AddIdentificationNumberToSchools < ActiveRecord::Migration[6.1]
  def change
    add_column :schools, :identification_number, :string
    add_index :schools, :identification_number,   unique: true
  end
end
