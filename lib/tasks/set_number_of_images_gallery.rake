task :set_number_of_images_gallery => :environment do
  Gallery.includes(:attachments).each do |gallery|
    gallery[:number_of_images] = gallery.attachments.length
    gallery.save!(validate: false)
  end
end