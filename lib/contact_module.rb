module ContactModule
  FILTERS = %w[common from to]
  SORT_DEFAULT = "contacts.created_at"
  MODEL_NAME = 'contact'
  TO_INCLUDES = []
  DEFAULT_ARGUMENT = 'messages' unless const_defined?(:DEFAULT_ARGUMENT)
  
end