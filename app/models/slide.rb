class Slide < ActiveRecord::Base
  belongs_to :presentation
  acts_as_list :scope => :presentation
  alias :previous :higher_item 
  alias :next :lower_item 

  serialize :content
  
  def slot(name)
    Slot.new(name, content[name])# if content && content[name]
  end
  def slots
    slot_names = []
    t = TemplateManager.inner_template(presentation.template, self.template)
    if t
      slots = t["slots"].inject([]) do |a, name|
        slot_names << name
        a << Slot.new(name, content && content[name])
      end
    end
    if content
      content.each do |k, v|
        slots << Slot.new(k, v, false) unless slot_names.include?(k)
      end
    end
    slots
  end
end
