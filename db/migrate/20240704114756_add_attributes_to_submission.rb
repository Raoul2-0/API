class AddAttributesToSubmission < ActiveRecord::Migration[6.1]
  def change
    add_column :submissions, :teacher_comment, :text
    add_column :submissions, :correctness, :boolean
    add_reference :submissions, :attend_scholastic_period, null: false, foreign_key: true
  end
end
