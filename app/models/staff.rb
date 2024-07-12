class Staff < ApplicationRecord
  include Userable
  include Monitorable
  include StaffModule
  
  has_many :serves, class_name: "Serve"
  has_many :schools, through: :serves
  accepts_nested_attributes_for :serves
  
  #validates :signature, format: { with: /\A<svg.*<\/svg>\z/i, message: I18n.t('activerecord.errors.models.staff.attributes.signature.invalid_svg')  }

  def enableServes
    serves.enable_serve
  end

end
