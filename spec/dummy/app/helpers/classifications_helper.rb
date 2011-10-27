module ClassificationsHelper
  def label_select(facet, label_id)
    options = content_tag(:option, "")
    options << options_from_collection_for_select(facet.labels, :id, :caption, label_id)
    select_tag "classification[label_ids][]", options
  end
end
