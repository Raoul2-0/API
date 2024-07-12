class DecodeSerializer < BaseSerializer
  attributes :id, 
             :cod, 
             :denomination, :description, :school_id, 
             :decode_configuration_id,
             :short_updated_at,
             :short_created_at,
             :school_denomination

end
