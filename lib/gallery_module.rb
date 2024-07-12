module GalleryModule
  LIMIT_ATTACHMENTS = { images: 10 } unless const_defined?(:LIMIT_ATTACHMENTS)
  FILTERS = %w[common]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'gallery'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'galleries' unless const_defined?(:DEFAULT_ARGUMENT)
end