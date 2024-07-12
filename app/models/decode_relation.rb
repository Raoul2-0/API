class DecodeRelation < ApplicationRecord
  belongs_to :decodable, polymorphic: true
  belongs_to :decode
end
