class GallerySerializer < BaseSerializer
  include AttachmentModule
  attributes :id, :cover_image_id, :denomination, :description, :attachments
end
