class AttachmentPolicy < ResourcePolicy
  def model_name
    'attachment'
  end

  def add_files?
    user.admin?
  end
end