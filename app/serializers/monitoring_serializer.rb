class MonitoringSerializer < ActiveModel::Serializer
  include Utils
  attributes :id, :create_who_fullname, :update_who_fullname, :status, :start_date, :end_date , :monitorable_type, :monitorable_id,#, :create_who_id, :update_who_id
  

  def create_who_fullname
    object.get_full_name("create")
  end

  def update_who_fullname
    object.get_full_name("update")
  end
end