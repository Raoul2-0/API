module StatisticModule
  FILTERS = %w[common]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'statistic'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'statistics' unless const_defined?(:DEFAULT_ARGUMENT)
end