class AddReferenceHomeworkToSolution < ActiveRecord::Migration[6.1]
  def change
    add_reference :solutions, :homework, null: false, foreign_key: true
  end
end
