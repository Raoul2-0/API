module ParentModule
  DEFAULT_ARGUMENT = 'parents' unless const_defined?(:DEFAULT_ARGUMENT)
  FILTERS = %w[]
  SORT_DEFAULT = "" #parents_translations.occupation
  MODEL_NAME = 'parent'
  TO_INCLUDES = [:translations]
  
  def save_parent(resource, parameters, school_id = request.headers['X-school-id'])
    parent_attributes = {"occupation" => parameters[:parent_attributes]["occupation"]}
    parent = Parent.create!(parent_attributes)
    resource.update!({"userable_type" => "Parent", "userable_id" => parent.id})
    update_monitor(parent, Constant::RESOURCE_METHODS[:create], { user: resource, monitor_attributes: {} })
    resource.create_permissions(school_id)
  end
end