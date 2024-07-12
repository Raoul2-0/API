class AddRootIdParentIdToSchool < ActiveRecord::Migration[6.1]
  def change
    add_reference(:schools, :root,  null: true, foreign_key: { to_table: :schools })
    add_reference(:schools, :parent, null: true, foreign_key: { to_table: :schools })
  end
end
