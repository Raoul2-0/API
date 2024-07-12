class AttachmentSerializer < ActiveModel::Serializer #BaseSerializer
  attributes :id, :category, :file_id, :filename, :url, :content_type #, :created_at, :updated_at , :monitor
  def created_at
    #object.created_at.strftime("%B %-d, %Y") "created_at": "May 18, 2022 19:0
    I18n.l(object.created_at, format: :short)
    #object.human_created_at #=> "Mon, 04 Jun 1984 09:20:00 +0000"

    # I18n.l(object.created_at, format: :long)
  end
  def updated_at
    #object.updated_at.strftime("%B %-d, %Y")
    I18n.l(object.updated_at, format: :short)
    # I18n.l(object.updated_at, format: :long)
    #object.human_updated_at #=> "1984"
  end
end
