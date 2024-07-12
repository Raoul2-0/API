class AddAttachableToAttachments < ActiveRecord::Migration[6.1]
  def change
    add_reference :attachments, :attachable, polymorphic: true, index: true
  end
end
