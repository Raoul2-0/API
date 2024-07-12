module Hierarchizable
  extend ActiveSupport::Concern

  included do
    # start creating hierarchy on school (a root school does not have parent and root hence , optional: true)
    # creating root school
    has_many :descendants, class_name: "School", foreign_key: "root_id"
    belongs_to :root, class_name: "School"
    # creating parent 
    has_many :children, class_name: "School", foreign_key: "parent_id"
    belongs_to :parent, class_name: "School"
  # end hierarchy creation
  end
end