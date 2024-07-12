class ParametersConfig
  include ActiveModel::Model
  include ActiveModel::Validations

  REQUIRED_ATTRS = %i[school_id cod key]
  NOT_REQUIRED_ATTRS = %i[value value_type]
  TABLE_ATTRS = REQUIRED_ATTRS + NOT_REQUIRED_ATTRS
  
  attr_accessor(*TABLE_ATTRS)

  validates(*REQUIRED_ATTRS, presence: true)

  def self.by_school(id = nil)
    return [] unless id
    
  end

end