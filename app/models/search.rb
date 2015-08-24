class Search

  def self.search(query, filter = nil)
    return if query.blank?

    classes = []
    classes << filter.classify.constantize unless filter.blank?

    ThinkingSphinx.search query, classes: classes
  end

end