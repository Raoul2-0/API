module Homeworkable
    extend ActiveSupport::Concern
  
    included do
      resourcify
      has_many :homeworks, as: :homeworkable
  
      delegate :homeworkable_type, :homeworkable_id, to: :homework, allow_nil: true
    end
end