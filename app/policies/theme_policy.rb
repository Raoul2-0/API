class ThemePolicy < ResourcePolicy
  def model_name
    'theme'
  end

  LOCAL_ACTIONS = ['create', 'update', 'delete']
  LOCAL_ACTIONS.each do |c|
    define_method "#{c}?" do
      admin?
    end
  end 
end
