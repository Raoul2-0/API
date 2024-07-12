class Gallery < ApplicationRecord
  include GalleryModule
  include Attachable
  include Monitorable
  
  acts_as :detail
  alias_attribute :initials, :default_initials
  validates_presence_of :denomination#, :cover_image_id


  scope :by_common, ->(term) { where("lower(detail_translations.denomination) ILIKE ?", "%#{term}%") }
  
  def self.fetch_resources(params, parent_model, user)
    
    parameters = {
      parent_model: parent_model,
      to_includes: TO_INCLUDES,
      status: params[:status]
    }
    
    resources = set_resources(MODEL_NAME, parameters)
   
    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
    
    resources.reorder(sort)
  end

  def avatar_url
    attachments&.find_by_category('images')&.select {|image| image.id == cover_image_id}[0]&.url
  end
end
