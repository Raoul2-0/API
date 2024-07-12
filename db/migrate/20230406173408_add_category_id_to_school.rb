class AddCategoryIdToSchool < ActiveRecord::Migration[6.1]
  def change
    add_column :schools, :category_id, :integer,  default: 1, null: false
  end
end
