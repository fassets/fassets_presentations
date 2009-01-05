# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def submit_button(value, cancel=nil)
    content = submit_tag(value)
    content << "&nbsp;or&nbsp;#{cancel}" if cancel
    content_tag :div, content, :class => 'submit'
  end
  
  
  def asset_content_path(content, options={})
    send("#{content.class.to_s.underscore}_path", content)
  end
  def edit_asset_content_path(content)
    send("edit_#{content.class.to_s.underscore}_path", content)
  end

  def render_content_partial(content, style)
    path = "/#{content.class.to_s.pluralize.underscore}/#{content.media_type.downcase}_#{style.to_s}"
    render :partial => path , :locals => {:content => content}
  end
  
  def include_js(file)
    content_for :head do
      javascript_include_tag file
    end
  end
  
  def render_escaped(option)
    escape_javascript(render(option))
  end
  
  def catalog_selector
    options = @catalog ? "" : content_tag(:option, "Browse...")
    options << options_from_collection_for_select(Catalog.all, :id, :title, @catalog ? @catalog.id : nil)
    select_tag("catalog", options, :id => "catalog_selector") 
  end
  
  def form_toggle_link(caption)
    link_to caption, "#", :class => "form_toggle"
  end
end


