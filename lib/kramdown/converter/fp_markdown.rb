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
      "\\foreign"+inner(el, indent).sub(/\n+\Z/, "\n")
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
    elsif el.attr['class'] == 'title'
      '["'+Kramdown::Converter::FP_Markdown.convert(Kramdown::Document.new(inner(el, indent).chomp, :input => "FP_Html").root)[0]+'"]'
    elsif el.attr['class'] == 'content'
      '{"'+Kramdown::Converter::FP_Markdown.convert(Kramdown::Document.new(inner(el, indent).chomp, :input => "FP_Markdown").root)[0]+'"}'
    elsif el.attr['class'] == 'translation'
      '{"'+Kramdown::Converter::FP_Markdown.convert(Kramdown::Document.new(inner(el, indent).chomp.chop[1..-1], :input => "FP_Markdown").root)[0]+'"}'
    else
      super
    end
  end
  def convert_br(el, opts)
    if el.attr['class'] == 'filler'
      el.attr.delete('class')
      ''
    else
      super
    end
  end
end
