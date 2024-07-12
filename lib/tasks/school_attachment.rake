require "#{Rails.root}/lib/cleaning"
require "#{Rails.root}/lib/attachment_module"
include Cleaning
include AttachmentModule

task :school_attachment, [:id]  => :environment do |t, args|
    high_school_path = Rails.root.to_s.split("/")[0..-2].join("/")
    images = high_school_path + "/eschool/public/images"
    galery = high_school_path + "/eschool/public/partners"
    
    galeries = ((1..10).to_a).map do |i| 
      "#{galery}/logo" + i.to_s + ".png" 
    end
    attachments = {
      main_logo: ["#{images}/logo.png"], 
      secondary_logo: ["#{images}/logoBlanc.png"], 
      main_banner: ["#{images}/details/BIG_BG.jpg"] ,
      secondary_banner: ["#{images}/details/SMALL_BG.jpg"],
      galery: galeries
      }
    # create_after_upload!(io: file, filename:"logo.png", content_type: "image/png")
    #Attachment.delete_all
    Attachment.where(attachable_type: 'School').destroy_all

    # clean the attachment storage from module Cleaning 
    clean_storage
    @model = School.find_by_id(args[:id].to_i)

    # add attachments from attachmentModule
    if @model 
      add_local_attachments(attachments, @model, @model)
    end

end