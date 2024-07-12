class Detail < ApplicationRecord
  actable
  translates :denomination, :description  
# validate detail attributes for statistic 
# with_options if: proc { |x| x.actable_type == 'Statistic'} do |s|
#   s.validates :denomination, :description, presence: true 
# end

# validate  detail attributes for Event
# with_options if: proc { |x| x.actable_type == 'Event'} do |s|
#   s.validates :denomination, presence: true 
# end
# validate detail attributes for news 
# with_options if: proc { |x| x.actable_type == 'News'} do |s|
#   s.validates :denomination, :description, presence: true 
# end
end
