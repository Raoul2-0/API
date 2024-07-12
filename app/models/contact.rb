class Contact < ApplicationRecord
  include Monitorable
  include ContactModule

  scope :by_from, lambda { |from|
    
    where('contacts.created_at::date >= ?', from) if from
  }
  scope :by_to, lambda { |to|
    where( 'contacts.created_at::date <= ?', to ) if to
  }
  scope :by_common, lambda { |readed|
    where(readed: readed)
  }

  def self.fetch_resources(params, parent_model, user)
    
    parameters = {
      parent_model: parent_model,
      to_includes: TO_INCLUDES,
      status: params[:status]
    }
    
    resources = set_resources(MODEL_NAME, parameters)
    
    resources = apply_filters(params, resources, FILTERS)
    sort = params[:sort].present? ? params[:sort].gsub(/_(a|de)sc(!|$)/, ' \1sc\2').split('!').map(&:to_s) : SORT_DEFAULT
    
    resources.reorder(sort)
  end
end
