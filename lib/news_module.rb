module NewsModule
  LIMIT_ATTACHMENTS = {avatar: 1} unless const_defined?(:LIMIT_ATTACHMENTS) # limit the number of attachments for news to 1
  FILTERS = %w[common from to foreground sidebar status]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'news'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'news' unless const_defined?(:DEFAULT_ARGUMENT)
end