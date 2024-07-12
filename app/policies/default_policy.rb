module DefaultPolicy
  COMMON_ACTIONS = ['create','index', 'show', 'update', 'delete', 'print']
  COMMON_ACTIONS.each do |c|
    define_method "#{c}?" do
      model_name ? is_admin_or_has_permission?("#{model_name}:#{c}") : false
    end
  end

  def model_name
    nil
  end

  def destroy?
    admin? 
  end

  def destroys?
    admin? 
  end
end