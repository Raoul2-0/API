module Userable
  extend ActiveSupport::Concern

  included do
    has_one :user, as: :userable
    delegate :fullname, :birthdate, :address, :initials, :small_gender, :identification_number, :all_phones, :email, :gender, :complete_address, :complete_birthdate, :avatar_url, :disabled, to: :user, allow_nil: false  
    delegate :id, to: :user, prefix: true, allow_nil: false  
  end
end