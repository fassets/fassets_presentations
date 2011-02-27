module PresentationsHelper
  def template_path(template)
    File.join(TEMPLATE_PATH, template).to_s
  end
  def render_inner_template(slide)
    template = slide.presentation.template;
    render(
      :file => File.join(template_path(template), slide.template + ".html.haml").to_s,
      :locals => {:slide => slide}
    )
  end
  def render_slot(slot, css_class="")
    return "" unless slot
    if slot["mode"] == "asset"
      render_content_partial(slot.asset.content, "preview", css_class) if slot.asset
    else
      content_tag :div, Markup.to_html(slot["markup"]), :id =>"markup_#{Time.now.to_s[0]}" , :class => "markup #{css_class}"
    end
  end
end
