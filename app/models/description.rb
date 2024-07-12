class Description < ApplicationRecord
  # this description table only enable validation to succeed from SCRATCH
  actable
  translates :denomination, :description  
end
