class ClassLevelSerializer < ActiveModel::Serializer
  attributes :id, :cod, :denomination, :category_id, :phase_id

  def meta
    { class: object.class.name }
  end
end
