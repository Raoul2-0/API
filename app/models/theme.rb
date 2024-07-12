class Theme < ApplicationRecord 
  include ThemeModule
  include Attachable
  include Monitorable
  
  has_many :schools
  alias_attribute :initials, :default_initials
  
  validates_presence_of :denomination, :colors
  validates_uniqueness_of :denomination
  validate :colors_against_json_schema

  scope :by_common, lambda { |term| where("lower(denomination) ILIKE ?", "%#{term}%")}

  has_defaults(
    colors: proc {
      {
        black: "",
        white: "",
        primary: "",
        secondary: "",
        grey_variant_1: "",
        black_variant_1: "",
        primary_variant_1: "",
        primary_variant_2: "",
        primary_variant_3: "",
        primary_variant_4: "",
        primary_variant_5: "",
      }
    }
  )
  
  # validate colors jsonb
  def colors_against_json_schema
    validate_json_schema(modality="strict", json_name="colors", json_value=colors)
  end

  def self.fetch_resources(params, school, user )
    resources = Theme.by_undeleted
   
    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
    
    resources.reorder(sort)
  end

  def avatar_url
    attachments.find_by_category('home_page')[0]&.url
  end

  def minimal_block
    {
      id: id, 
      denomination: denomination, 
      colors: colors
    }
  end

  def number_of_school
    schools.length
  end
end
