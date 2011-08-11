module ApplicationHelper
  def tree_ol(acts_as_tree_set, init=true, &block)
    if acts_as_tree_set.size > 0
      if init
        ret = '<ol class="sortable">'
      else
        ret = '<ol>'
      end
      acts_as_tree_set.collect do |item|
        next if item.parent_id && init
        ret += '<li id="topic_'+item.id.to_s+'" class="topic"><div>'
        ret += yield item
        unless item.slides.empty?
          ret += '<ol class="sortable_slides" path=presentations.'+item.presentation_id.to_s+'.slides.sort>'
        end
        item.slides.each do |slide|
          ret += '<li id=slide_'+slide.id.to_s+' topic_id='+item.id.to_s+' class="slide">'
          ret += '<div>'+link_to(slide.title,edit_presentation_slide_path(slide.presentation, slide))+'</div>'
          ret += '</li>'  
        end
        unless item.slides.empty?
          ret += '</ol>'
        end
        ret += tree_ol(item.children, false, &block) if item.children.size > 0
        ret += '</div></li>'
      end
      ret += '</ol>'
    end
    ret.html_safe
  end
end
