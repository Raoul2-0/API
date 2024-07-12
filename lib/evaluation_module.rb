module EvaluationModule
  FILTERS = %w[common]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'evaluation'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'evaluations' unless const_defined?(:DEFAULT_ARGUMENT)
end