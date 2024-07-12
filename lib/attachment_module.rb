module AttachmentModule
  include Utils
  # build a single attachment 
  def build_attachment(category)
    attachment = filter_resources(object.attachments.find_by_category(category))
    attachment ? AttachmentSerializer.new(attachment) : nil
  end

  # build an array of attachments
  def build_attachments(category)
    attachments = filter_resources(object.attachments.find_by_category(category)) #.find_by_non_deleted
    attachments.any? ? ActiveModel::Serializer::CollectionSerializer.new(attachments, each_serializer: AttachmentSerializer) : []
  end

  # build images of an attachments
  def build_images(categories)
    categories = [categories] if categories.instance_of? String
    attachments = {}
    categories.each do |category|
      attachments[category.to_sym] = build_attachments(category)   
    end
    attachments
  end
  
  # return the attachments for a given resource
  def attachments
    build_images(get_attachments_categories(object))
  end

  # add attachments to a @model from local files
   def add_local_attachments(attachments, resource, school)
    attachments.each do |category, paths|
      paths.each do |path|
        file_io = File.open(path, 'rb') 
        name = path.split('/').last
        content_type = "image/" + name.split('.').last
        file_to_attach = ActiveStorage::Blob.create_and_upload!(io: file_io, filename: name, content_type: content_type)
        add_single_attachment(resource, category, file_to_attach)
        # attach = Attachment.create(attachable: model)
        # attach.files.attach(file)
        # attach.save! # this first save is done to enable file_id
        # attributes = {category: category, file_id: attach.files[0].id, filename: attach.files[0].filename.to_s, url: Rails.application.routes.url_helpers.url_for(attach.files[0]), content_type: attach.files[0].content_type}
        # attach.update!(attributes)
      end
    end
   end

  # Add attachments to a resource
  def add_attachments(resource, attachments, school)
    
    authorize resource, policy_class: AttachmentPolicy unless skip_authorization

    #onDrive = school.attachments_link_file?
    attachments.each do |attachment|
        category = attachment[0]
        attachment[1].each do |file_to_attach|
          add_single_attachment(resource, category, file_to_attach)   
        end
    end
  end

  # Adds a single attachment to a resource
  def add_single_attachment(resource, category, file_to_attach)
    
    AttachmentHandler.handle_attachment!(resource, category)
    attach = Attachment.create(attachable: resource)
    
    if School.super_school.attachments_link_file?
      attributes = {
        category: category, 
        file_id: attach.id,
        filename: file_to_attach[:filename], 
        url: file_to_attach[:url],
        content_type: file_to_attach[:content_type], 
      }

    else
      attach.files.attach(file_to_attach)
      attach.save! # this first save is done to enable file_id

      attributes = {
        category: category, 
        file_id: attach.files[0].id, 
        filename: attach.files[0].filename.to_s, 
        url: Rails.application.routes.url_helpers.url_for(attach.files[0]), 
        content_type: attach.files[0].content_type
      }
    end
    
    attach.update!(attributes)
    resource.reload
    options = { user: try('current_user') || User.default_super_user }
    update_monitor(attach, Constant::RESOURCE_METHODS[:create], options)
    
    attach.reload
  end

  # return the attachment categories of a resource
  def get_attachments_categories(resource)
    resource_name=resource.model_name.name.constantize
    resource_name.const_defined?(:LIMIT_ATTACHMENTS) ? resource_name::LIMIT_ATTACHMENTS.keys.map(&:to_s) : []
  end


  # Class to handle attachments (e.g exceed number of attachments)
  class AttachmentHandler
    # Domain specific errors
    class AttachmentExceedLimitError < StandardError
      attr_reader :resource
      def initialize(msg="Number of attachments exceeded", resource)
        @resource = resource
        resource_name = @resource.model_name.name.camelize.constantize
        msg  = I18n.t 'overflow_attachment', resource_name: @resource.model_name, limit_attachments: resource_name::LIMIT_ATTACHMENTS, scope: 'global'
        super(msg)
      end
    end

    
    def self.handle_attachment!(resource,category)
      raise AttachmentExceedLimitError.new(resource) if validate_attachment?(resource,category)
    end
    
    # delete the old attachment associated to a record  or the unique if the limit is one.
    def self.delete_old_attachment(resource,category)
      old_attachment = resource.attachments.where(category: category).order(:created_at).limit(1)[0]
      old_attachment.files.purge
      #clean_storage # clean the empty directory after files are purged
      # remove the monitoring of the associted attachments
      old_attachment.monitoring.destroy! if old_attachment.monitoring
      # delete the current attachment
      old_attachment.destroy!
    end

    # Checks if a resource has a limited number of attachments
    def self.validate_attachment?(resource,category)
      category_symbol = category.to_sym
      resource_string_name = resource.model_name.name
      resource_name = resource_string_name.constantize
      if resource_name.const_defined?(:LIMIT_ATTACHMENTS) && resource_name::LIMIT_ATTACHMENTS.key?(category_symbol)  #resource_name::LIMIT_ATTACHMENTS.exists?
        # if the number of number of attachments exceed remove the old attachment and proceed with the attachment of the new one 
        delete_old_attachment(resource,category) if resource.attachments.where(category: category).length >= resource_name::LIMIT_ATTACHMENTS[category_symbol]
        false
      else
        false
      end
    end
  end
end