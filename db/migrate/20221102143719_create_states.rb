class CreateStates < ActiveRecord::Migration[6.1]
  def change
    create_table :states do |t|
      t.boolean :isEnable,  default: false
      t.actable # shortcut for t.integer :actable_id and t.string  :actable_type
      #t.timestamps
    end
  end
end
