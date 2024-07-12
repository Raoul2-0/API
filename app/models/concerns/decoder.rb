module Decoder
  extend ActiveSupport::Concern

  included do
    has_many :decode_relations
    #has_many :collaborators, through: :decode_relations
  end
end