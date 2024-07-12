class BaseConfigureActivitySerializer < ActiveModel::Serializer
  include AttachmentModule
  attributes :id, :description, :attachments

  # def attachments
  #   build_attachments(object.denomination)
  # end
end