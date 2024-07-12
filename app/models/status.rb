class Status < ApplicationRecord
  DISABLED = 0 unless const_defined?(:DISABLED) # the resource is blocked and anz CRUD cannot be done (e.g: a user is banned and cannot perform login)
  ACTIVATED = 1 unless const_defined?(:ACTIVATED) # default status at the creation (visible only by who created)
  DELETED = 2 unless const_defined?(:DELETED) # a school deletes a resource
  CANCELED = 3 unless const_defined?(:CANCELED) # a resource is temporary cancel (e.g an event is temporary canceled and can be resumed later)
  PUBLISHED = 4 unless const_defined?(:PUBLISHED) # everyone has access to the resource

  COLORS = { '0' => 'green', '1' => 'black', '3' => 'red', '4' => 'green' } unless const_defined?(:COLORS)
end