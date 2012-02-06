require "kramdown"

module PresentationsHelper
  include AssetsHelper
  def template_path(template)
    logger.debug("Bar")
    File.join(TEMPLATE_PATH, template).to_s
  end
  def render_inner_template(frame)
    template = frame.presentation.template;
    render(
      :file => File.join(template_path(template), frame.template + ".html.haml").to_s,
      :locals => {:frame => frame}
    )
  end
  def render_slot(slot, css_class="")
    return "" unless slot
    if slot["mode"] == "asset" and slot.asset
      @content = slot.asset.content
      render :partial => content_partial(slot.asset.content, "preview") if slot.asset
    else
      Kramdown::Document.new(slot["markup"]).to_html
    end
  end
  def tree_ol(acts_as_tree_set, init=true, &block)
    if acts_as_tree_set.size > 0
      if init
        ret = '<ol class="sortable_frames">'
      else
        ret = '<ol>'
      end
      acts_as_tree_set.collect do |item|
        #next if item.parent_id && init
        ret += '<li id="frame_'+item.id.to_s+'" class="frame"><div>'
        ret += yield item
        ret += '</div>'
        ret += tree_ol(item.children, false, &block) if item.children.size > 0
        ret += '</li>'
      end
      ret += '</ol>'
    end
    unless ret == nil
      ret.html_safe
    end
  end
  def menutree_ol(acts_as_tree_set, init=true, &block)
    if acts_as_tree_set.size > 0
      if init
        ret = '<ol class="frame_menu">'
      else
        ret = '<ol>'
      end
      number = 1
      acts_as_tree_set.collect do |item|
        #next if item.parent_id && init
        ret += '<li id="'+item.position.to_s+'">'
        ret += yield item
        ret += menutree_ol(item.children, false, &block) if item.children.size > 0
        ret += '</li>'
        number += 1
      end
      ret += '</ol>'
    end
    unless ret == nil
      ret.html_safe
    end
  end
end
