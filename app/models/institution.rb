class Institution < ApplicationRecord
  belongs_to :institutionalisable, :polymorphic => true
  belongs_to :school
  # delegate :root_id, :parent_id, :denomination, :identification_number, :sub_denomination, 
  # :slogan, :history, :admission_generality, :sub_description, :contacts_info, :social_media, 
  # :terms_condition, :privacy_policy, :protocol, :cookies_policy, :social,
  # :attachments, :current_scholastic_period, to: :school, prefix: true, allow_nil: true
end
