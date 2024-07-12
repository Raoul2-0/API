class Monitoring < ApplicationRecord
  # useful Model for monitoring other models
  belongs_to :monitorable, :polymorphic => true# , optional: true
  belongs_to :create_who, :class_name => 'User', :foreign_key => 'create_who_id'
  belongs_to :update_who, :class_name => 'User', :foreign_key => 'update_who_id', optional: true
  #belongs_to :delete_who, :class_name => 'User', :foreign_key => 'delete_who_id', optional: true

  

  # useful for serializer
  def get_full_name(category)
    id_user = category == "create" ? self.create_who_id : self.update_who_id
    if id_user.nil?
      ""
    else
     user = get_user_by_id(id_user)
     user.nil?  ? "" : user.fullname
    end
  end
end
