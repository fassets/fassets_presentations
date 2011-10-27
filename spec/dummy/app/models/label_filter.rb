class LabelFilter < Array
  def initialize(filter_query)
    label_ids = (filter_query || "").split('-').map{|id| id.to_i}
    super(label_ids)
  end
  def to_condition
    "labelings.label_id IN(#{self.join(',')})"
  end
  def to_query_include(id)
    (self + [id]).join('-')
  end
  def to_query_exclude(id)
    self.reject{|i| i == id}.join('-')
  end
end