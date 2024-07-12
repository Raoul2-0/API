class CollaboratorSerializer < BaseSerializer
  include AttachmentModule
  attributes :id, :school_id, :category, :denomination, :link, :description, :attachments
end
