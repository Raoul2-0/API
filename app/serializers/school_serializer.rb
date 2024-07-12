class SchoolSerializer < BaseSerializer
  include AttachmentModule
  attributes :id, :category_id, :root_id, :parent_id, :denomination, :identification_number, :sub_denomination, 
             :slogan, :history, :mission, :vision, :admission_generality, :sub_description, :contacts_info, :social_media, 
             :terms_condition, :privacy_policy, :protocol, :cookies_policy, :social,
             :attachments,
             :current_scholastic_period, :activities_description, :internal_rules,
             :sigle_attachment_urls, :parameters, :all_phones, :initials
  belongs_to :theme
  #attributes :denomination

  #has_many :extra_activities
  #has_many :contacts
  def current_scholastic_period
    object.current_scholastic_period(@instance_options[:scholastic_period_id])
  end
end