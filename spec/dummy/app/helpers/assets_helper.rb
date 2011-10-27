module AssetsHelper
  def content_partial(content, partial)
    content.class.to_s.underscore.pluralize + "/" + content.media_type.to_s.underscore + "_" + partial.to_s 
  end
  def asset_content_path(content, asset_id)
    content.underscore.pluralize + "/" + asset_id.to_s
  end
  def edit_asset_content_path(content, asset_id)
    content.underscore.pluralize + "/" + asset_id.to_s + "/edit"
  end
end
