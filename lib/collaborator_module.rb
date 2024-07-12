module CollaboratorModule
  LIMIT_ATTACHMENTS = {logo: 1} unless const_defined?(:LIMIT_ATTACHMENTS)
  FILTERS = %w[common category]
  SORT_DEFAULT = "detail_translations.denomination"
  MODEL_NAME = 'collaborator'
  TO_INCLUDES = [[detail: :translations], :translations]
  DEFAULT_ARGUMENT = 'collaborators' unless const_defined?(:DEFAULT_ARGUMENT)
  DECODE_LIST = [
    { cod: :category, group_key: 'collab_cat' }
  ]
end
