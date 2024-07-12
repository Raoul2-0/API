class ContactSerializer < BaseSerializer
  attributes :id, :school_id, :first_name, :last_name, :email, :phone_number, :message, :readed, :send_date
  def send_date
    object.created_at
  end
end
