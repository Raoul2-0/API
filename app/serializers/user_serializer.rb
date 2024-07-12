class UserSerializer < BaseSerializer
  attributes :id,  :email, :fullname , :sex, :identification_number, :birthday, :phones, :address, :email_confirmed, :disabled, :is_admin, :preferences # :first_name, :last_name
end