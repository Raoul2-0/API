class DecodeConfigurationSerializer < ActiveModel::Serializer
  attributes :id, :group_key, :common, :denomination, :description
end
