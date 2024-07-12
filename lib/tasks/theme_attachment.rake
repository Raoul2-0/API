require "#{Rails.root}/lib/cleaning"
require "#{Rails.root}/lib/attachment_module"
include Cleaning
include AttachmentModule

task :theme_attachment, [:id]  => :environment do |t, args|
    high_school_path = Rails.root.to_s.split("/")[0..-2].join("/")
    images = high_school_path + "/eschool/public/images/themes_images"
  
    theme = images + "/theme"+rand(1..5).to_s + ".jpg"
    attachments = {
      home_page: [theme]
      }
    # create_after_upload!(io: file, filename:"logo.png", content_type: "image/png")
    #Attachment.delete_all
    Attachment.where(attachable_type: 'Theme').destroy_all

    # clean the attachment storage from module Cleaning 
    clean_storage
    @model = Theme.find_by_id(args[:id].to_i)

    # add attachments from attachmentModule
    if @model 
      add_local_attachments(attachments, @model, School.super_school)
    end
end