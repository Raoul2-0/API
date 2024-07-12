class Attachment < ApplicationRecord
  include Monitorable
  #belongs_to :attachable, polymorphic: true, counter_cache: :number_of_images
  belongs_to :attachable, polymorphic: true 

  # after_create :increment_gallery_image_count, if: :image_attachment?

  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  has_many_attached :files

  #after_create :update_number_of_images
  #after_update :update_number_of_images
  
  scope :find_by_category, lambda { |category| where(category: category)} # return attachment by category
  #scope :find_by_non_deleted, lambda { where(self.monitoring[:status] != Status::DELETED)} # return attachment by category

  #validates_presence_of :category, :file_id, :filename, :url, :content_type
  #humanize :created_at, datetime: true
  # humanize :created_at, datetime: { format: :short }
  #humanize :updated_at, datetime: { format: :short }
  
  private


  # def image_attachment?
  #   category == 'images'
  # end


  def increment_counter_cache
    increment_gallery_image_count
  end

  def decrement_counter_cache
    increment_gallery_image_count
  end

  def increment_gallery_image_count
    return unless attachable.respond_to?(:number_of_images)

    attachable.increment!(:number_of_images) if attachable_type == 'Gallery' 
  end
end
