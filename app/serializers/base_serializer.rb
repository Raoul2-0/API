class BaseSerializer < ActiveModel::Serializer
  include Utils#, only: [:get_resource_by_id]
  public :get_resource_by_id # this makes available only the method :get_resource_by_id from Utils module
  attributes  :monitor
  def monitor
    return if object.blank?
    monitor = object&.monitoring
    if monitor
      id_user_create = monitor.create_who_id
      id_user_update = monitor.update_who_id || id_user_create # if update_who_id does not exit choose create_who_id
      user_create = get_resource_by_id(id_user_create, "user")
      user_update = get_resource_by_id(id_user_update, "user")
      create_who_fullname =  user_create ? user_create.fullname : " "
      update_who_fullname =  user_update ?  user_update.fullname : " "
      { 
        id: monitor.id,
        create_who_fullname: create_who_fullname,
        update_who_fullname: update_who_fullname,
        status: monitor.status,
        start_date: monitor.start_date,
        end_date: monitor.end_date,
       }
    else
      nil
    end
  end
end
