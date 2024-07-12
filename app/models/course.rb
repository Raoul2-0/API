class Course < ApplicationRecord
  #before_validation :generate_code, on: :create
  include Monitorable
  include CourseModule
  include Reportable
  include Decodable
  include Homeworkable
  acts_as :detail
  alias_attribute :minimal_block, :default_minimal_block
  belongs_to :classroom
  has_many :evaluations
  belongs_to :scholastic_period
  validates :scholastic_period, presence: true # a course should always belongs to a scholastic period

  validates :denomination, presence: true

  has_many :course_serves
  has_many :serves, through: :course_serves
  belongs_to :course_generality

  scope :by_common, lambda { |term| where("lower(detail_translations.denomination) ILIKE ?", "%#{term}%")}

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
  
  private

  def generate_code
    if denomination.present? && classroom_id.present?
      # Normaliser et supprimer les accents
      normalized_denomination = I18n.transliterate(denomination)
  
      denomination_split = normalized_denomination.split
      if denomination_split.length >= 3
        initials = denomination_split.select { |word| word.length >= 3 }.map { |word| word[0] }.join
      elsif denomination_split.length > 1
        initials = denomination_split.map { |word| word[0] }.join
      else
        initials = denomination_split[0][0, 3]
      end
      self.code = "#{initials.upcase}#{classroom.class_level_id}"
    end
  end
  
end
