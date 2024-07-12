module DecodeConfigurationModule
  FILTERS = %w[common group global]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'decode_configuration'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'decode_configurations' unless const_defined?(:DEFAULT_ARGUMENT)
end