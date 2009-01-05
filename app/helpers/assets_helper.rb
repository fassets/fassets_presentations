module AssetsHelper
  def content_partial(content, partial)
    @content.class.to_s.underscore.pluralize + "/" + partial
  end
end
