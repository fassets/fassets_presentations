require "kramdown"

class Kramdown::Converter::FP_Markdown < Kramdown::Converter::Kramdown
  def convert_html_element(el, indent)
    if el.attr['class'] == 'definition'
      el.attr.delete('class')
      "\\definition"+inner(el, indent).sub(/\n+\Z/, "\n")+"\n"
    elsif el.attr['class'] == 'example'
      el.attr.delete('class')
      "\\example"+inner(el, indent).sub(/\n+\Z/, "\n")+"\n"
    elsif el.attr['class'] == 'box'
      el.attr.delete('class')
      "\\box"+inner(el, indent).sub(/\n+\Z/, "\n")+"\n"
    elsif el.attr['class'] == 'foreign'
      el.attr.delete('class')
      "\\foreign"+inner(el, indent).sub(/\n+\Z/, "\n").gsub("(","").gsub(")","").gsub("\n","")
    elsif el.attr['class'] == 'cite'
      el.attr.delete('class')
      content = inner(el, indent).sub(/\n+\Z/, "\n")
      key = content.scan(/\[.+\]/)[0]
      quote = content.scan(/\{[^\}]+\}/)[0]
      "\\cite"+key+quote
    elsif el.attr['class'] == 'citation'
      '["'+el.attr['id']+'"]'
    elsif el.attr['class'] == 'quote'
      '{"'+inner(el, indent).chomp+'"}'
    elsif el.attr['class'] == 'type'
      ''
    elsif el.attr['class'] == 'delete'
      ''
    elsif el.attr['class'] == 'title'
      '["'+Kramdown::Converter::FP_Markdown.convert(Kramdown::Document.new(inner(el, indent).chomp, :input => "FP_Markdown").root)[0].gsub("\n","")+'"]'
    elsif el.attr['class'] == 'content'
      '{"'+Kramdown::Converter::FP_Markdown.convert(Kramdown::Document.new(inner(el, indent).chomp, :input => "FP_Markdown").root)[0]+'"}'
    elsif el.attr['class'] == 'translation'
      '{"'+Kramdown::Converter::FP_Markdown.convert(Kramdown::Document.new(inner(el, indent).chomp, :input => "FP_Markdown").root)[0]+'"}'
    elsif el.attr['class'] == 'clear'
      inner(el, indent)
    elsif el.attr['class'] == 'container'
      inner(el, indent)
    elsif el.attr['class'] == 'ui-resizable-handle ui-resizable-w'
      ''
    elsif el.attr['class'] == 'ui-resizable-handle ui-resizable-e'
      ''
    elsif el.attr['class'] == 'ui-resizable-handle ui-resizable-s'
      ''
    elsif el.attr['class'] == 'ui-resizable-handle ui-resizable-se ui-icon ui-icon-gripsmall-diagonal-se'
      ''
    else
      super
    end
  end
  def convert_p(el, opts)
    el.attr.delete('class')
    el.attr.delete('style')
    super
  end
  def convert_header(el, opts)
    el.attr.delete('id')
    el.attr.delete('class')
    el.attr.delete('style')
    super  
  end
end
