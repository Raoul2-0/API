class AddSignatureToStaffs < ActiveRecord::Migration[6.1]
  def change
    add_column :staffs, :signature, :text, default: ""
  end
end
