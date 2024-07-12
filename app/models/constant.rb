class Constant < ApplicationRecord
  SERVICES_NAMES = ['eschool', 'elearning'] unless const_defined?(:SERVICES_NAMES)
  TYPE_OF_EXTRA_ACTIVITY = {cooperative: "cooperative", club: "club"}
  EXTRA_ACTIVITY_MEMBER_TYPE = {ordinary: "ordinary", president: "president"}
  RESET_PASSWORD_DEADLINE = 24.hours unless const_defined?(:RESET_PASSWORD_DEADLINE)
  USER_IDENTIFICATION_NUMBER_LENGTH = 14 unless const_defined?(:USER_IDENTIFICATION_NUMBER_LENGTH)
  SCHOOL_IDENTIFICATION_NUMBER_LENGTH = 11 unless const_defined?(:SCHOOL_IDENTIFICATION_NUMBER_LENGTH)
  CONTENT_TYPE = { png: 'image/png', jpg: 'image/jpg', jpge: 'image/jpge', pdf: 'application/pdf' } unless const_defined?(:CONTENT_TYPE)
  RESOURCE_METHODS = {create: "create", update: "update", delete: "destroy"}  unless const_defined?(:RESOURCE_METHODS)
  Constant::RESOURCE_METHODS[:update]
  @@payload = nil
  @@resource_saved = nil
  def self.payload
    @@payload
  end
  def self.set_payload(payload)
    @@payload = payload
  end

  def self.resource_saved
    @@resource_saved
  end
  def self.set_resource(resource)
    @@resource_saved = resource
  end
end 