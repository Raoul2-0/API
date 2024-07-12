module Decodable
  extend ActiveSupport::Concern

  included do
    has_many :decode_relations, as: :decodable
    has_many :decodes, through: :decode_relations

    def decodes_values(group_key)
      decodes.joins(:decode_configuration).where(decode_configurations: { group_key: group_key})
    end

    def build_decodes(params, decode_list)
      return unless decode_list

      decode_list.each do |dl|
        new_values = params[dl[:cod]]
      
        next unless new_values

        deco_ids = decodes_values(dl[:group_key])
        DecodeRelation.where(decode_id: deco_ids.pluck(:id), decodable_id: id).delete_all if deco_ids.present?
        
        new_values = [new_values] unless new_values.is_a?(Array)

        new_values.each do |nv|
          DecodeRelation.create(decode_id: nv, decodable: self)
        end
      end
    end
  end
end