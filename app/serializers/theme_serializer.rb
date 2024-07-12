class ThemeSerializer < BaseSerializer
  include AttachmentModule
  attributes :id, :denomination, :colors, :attachments
end
