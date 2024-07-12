class DecodeRelationSerializer < ActiveModel::Serializer
  attributes :id, :decode
  
  #has_one :decodable
end
