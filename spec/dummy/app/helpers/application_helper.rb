module ApplicationHelper
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
