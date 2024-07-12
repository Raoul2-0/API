class RemoveRootIdParentIiFromSchool < ActiveRecord::Migration[6.1]
  def change
    remove_column :schools, :root_id
    remove_column :schools, :parent_id
  end
end
