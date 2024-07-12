
module AttachmentHelpers
  def attachment_parameters
     {
       category: Faker::Types.rb_string ,
       file_id: Faker::Number.digit,
       filename: Faker::File.file_name(dir: 'path/to'),
       url: Faker::Internet.url,
       content_type: Faker::File.mime_type,
       #attachable_type: Faker::Types.rb_string,
       #attachable_id: Faker::Number.digit
    }
 end
 def 
 
 def create_attachment
  handle_monitoring(FactoryBot.create(:attachment, attachment_parameters))
 end
   
 def build_attachment
   FactoryBot.build(:attachment, attachment_parameters)
 end
end