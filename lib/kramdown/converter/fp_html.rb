require "kramdown"

class Kramdown::Converter::FP_Html < Kramdown::Converter::Html 
  def convert_definition(el, indent)
    title = el.value.scan(/\[.+\]/)[0]
    text = el.value.scan(/\{[^\}]+\}/)[0]
    title = title.gsub(/[\[\]"]/, "")
    text = text.gsub(/[{}"]/, "")
    text = Kramdown::Converter::FP_Html.convert(Kramdown::Document.new(text, :input => "FP_Markdown").root)[0]
    '<div class="definition"><div class="type">Definition:</div><div class="title">'+title+'</div><div class="content">'+text+'</div></div><br class="filler">'
  end
  def convert_example(el, indent)
    title = el.value.scan(/\[.+\]/)[0]
    text = el.value.scan(/\{[^\}]+\}/)[0]
    title = title.gsub(/[\[\]"]/, "")
    text = text.gsub(/[{}"]/, "")
    text = Kramdown::Converter::FP_Html.convert(Kramdown::Document.new(text, :input => "FP_Markdown").root)[0]
    '<div class="example"><div class="type">Example:</div><div class="title">'+title+'</div><div class="content">'+text+'</div></div><br class="filler">'
  end
  def convert_box(el, indent)
    title = el.value.scan(/\[.+\]/)[0]
    text = el.value.scan(/\{[^\}]+\}/)[0]
    title = title.gsub(/[\[\]"]/, "")
    text = text.gsub(/[{}"]/, "")
    text = Kramdown::Converter::FP_Html.convert(Kramdown::Document.new(text, :input => "FP_Markdown").root)[0]
    '<div class="box"><div class="title">'+title+'</div><div class="content">'+text+'</div></div><br class="filler">'
  end
  def convert_foreign(el, indent)
    title = el.value.scan(/\[.+\]/)[0]
    text = el.value.scan(/\{[^\}]+\}/)[0]
    title = title.gsub(/[\[\]"]/, "")
    text = text.gsub(/[{}"]/, "")
    '<div class="foreign"><div class="title">'+title+'</div><div class="translation">('+text+')</div></div>'
  end
end
