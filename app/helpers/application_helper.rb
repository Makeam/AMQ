module ApplicationHelper

  def is_owner_of?(obj)
    (user_signed_in? and (current_user.id == obj.user_id))
  end

  def is_not_owner_of?(obj)
    !is_owner_of?(obj)
  end

  def collection_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

  def cache_association_key(object, association_name, collection)
    count = collection.count
    max_updated_at = collection.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{object.model_name.name}/#{object.id}/collection-#{association_name}-#{count}-#{max_updated_at}"
  end

end
