class AddReferenceHomeworkToSubmission < ActiveRecord::Migration[6.1]
  def change
    add_reference :submissions, :homework, null: false, foreign_key: true
  end
end
