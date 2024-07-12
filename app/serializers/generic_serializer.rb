class GenericSerializer < BaseSerializer
  include AttachmentModule
  attributes :id, :school_id, :denomination, :description, :orientation, :page_name, :on_menu, :on_home, :on_fast_link, :attachments, :avatar_url, :initials
end
