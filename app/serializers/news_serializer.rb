class NewsSerializer < BaseSerializer
  include AttachmentModule
  attributes :id, :foreground, :sidebar, :school_id, :publication_date, :denomination, :sub_denomination, :description, :attachments

end
