class Generic < ApplicationRecord
  include GenericModule
  resourcify
  include Monitorable
  include Attachable
  
  acts_as :detail
  alias_attribute :minimal_block, :default_minimal_block
  alias_attribute :initials, :default_initials
  
  validates_presence_of  :denomination, :page_name
  scope :by_on_fast_link, lambda { where(on_fast_link: true)} # return generirs with fast_link=true
  scope :by_page_name, lambda { |page_name| where(page_name: page_name)} # return generic by page_name
  scope :by_common, lambda { |term| where("lower(detail_translations.denomination) ILIKE ?", "%#{term}%") }
  scope :by_principal_speech, lambda { by_page_name('welcomeMessages').by_on_home }
  scope :by_on_home, lambda { where(on_home: true)} # return generirs with on_home=true

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
    attachments.find_by_category('images')[0]&.url
  end

  # returns fast links grouped by page_name
  # def self.get_fast_links(generics)
  #   generics = generics.by_on_fast_link
  #   page_names = generics.distinct.pluck(:page_name)
  #   response = {}
  #   page_names.each { |page_name|
  #     fast_links = self.filter_resources(generics.by_page_name(page_name))
  #     response[page_name.to_sym] = JSON.parse(ActiveModelSerializers::SerializableResource.new(fast_links, each_serializer: GenericSerializer).to_json)
  #   }
  #   response
  # end
end
