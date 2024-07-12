class Homework < ApplicationRecord
    include Attachable
    include Monitorable
    include HomeworkModule
    acts_as :detail
    validates :denomination, presence: true
    validates :description, presence: true
    validates :optional, inclusion: { in: [true, false] }

    has_one :solution
    belongs_to :serve
    after_save :set_teacher_from_lesson
    belongs_to :homeworkable, polymorphic: true 
    has_many :submissions
    scope :by_common, lambda { |term| where("lower(detail_translations.denomination) ILIKE ?", "%#{term}%")}
  
    def self.fetch_resources(params, parent_model, user)
    
      parameters = {
        parent_model: parent_model,
        to_includes: TO_INCLUDES,
        status: params[:status]
      }
      
      resources = set_resources(MODEL_NAME, parameters)
      
      resources = apply_filters(params, resources, FILTERS)
      # sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
      # resources.reorder(sort)
    end

    def set_teacher_from_lesson
        if serve.blank? && lesson.present?
          update(serve: lesson.serve)
        end
    end
end
