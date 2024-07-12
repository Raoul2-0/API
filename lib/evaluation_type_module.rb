module EvaluationTypeModule 
  FILTERS = %w[common]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'decode'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'evaluation_types' unless const_defined?(:DEFAULT_ARGUMENT)
end
