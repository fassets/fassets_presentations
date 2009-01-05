module SlidesHelper
  def slot(name)
     @slide.slot(name)
  end
  def render_slot(name)
    slot = @slide.slot(name)
    if slot["mode"] == "asset"
      render_content_partial(slot.asset.content, "preview") if  slot.asset
    else 
      markup(slot["markup"])
    end
  end
  
  
  def markup(input)
    Markup.to_html(input)
  end
end
