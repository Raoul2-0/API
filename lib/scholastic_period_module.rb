module ScholasticPeriodModule
  FILTERS = %w[common start_date end_date status]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'scholastic_period'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'scholastic_periods' unless const_defined?(:DEFAULT_ARGUMENT)
end