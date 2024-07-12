module Localizable
  extend ActiveSupport::Concern

  included do
    has_one :local
    delegate  :capacity, :localisation, to: :local #, allow_nil: false  :denomination, :description,
    delegate :denomination, to: :local, prefix: true, allow_nil: false
  end
end  