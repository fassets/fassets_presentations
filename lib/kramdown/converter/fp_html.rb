require "kramdown"
require 'bibtex'
require 'citeproc'

class Kramdown::Converter::FP_Html < Kramdown::Converter::Html
  def convert_p(el, indent)
    el.attr["class"] = "sortable"
    super
  end
  def convert_definition(el, indent)
    title = el.value.scan(/\[\".*\"\]/)[0].to_s
    text = el.value.scan(/\{\"[^\}]+\"\}/)[0].to_s
    title = title.gsub(/[\[\]"]/, "")
    text = text.gsub(/[{}"]/, "")
    text = Kramdown::Converter::FP_Html.convert(Kramdown::Document.new(text, :input => "FP_Markdown").root)[0]
    '<div class="definition sortable"><div class="type">Definition:</div><div class="title">'+title.to_s+'</div><div class="content">'+text.to_s+'</div></div>'
  end
  def convert_example(el, indent)
    title = el.value.scan(/\[.+\]/)[0]
    text = el.value.scan(/\{[^\}]+\}/)[0]
    title = title.gsub(/[\[\]"]/, "")
    text = text.gsub(/[{}"]/, "")
    text = Kramdown::Converter::FP_Html.convert(Kramdown::Document.new(text, :input => "FP_Markdown").root)[0]
    '<div class="example sortable"><div class="type">Example:</div><div class="title">'+title+'</div><div class="content">'+text+'</div></div>'
  end
  def convert_box(el, indent)
    title = el.value.scan(/\[.+\]/)[0]
    text = el.value.scan(/\{[^\}]+\}/)[0]
    title = title.gsub(/[\[\]"]/, "")
    text = text.gsub(/[{}"]/, "")
    text = Kramdown::Converter::FP_Html.convert(Kramdown::Document.new(text, :input => "FP_Markdown").root)[0]
    '<div class="box sortable"><div class="title">'+title+'</div><div class="content">'+text+'</div></div>'
  end
  def convert_foreign(el, indent)
    title = el.value.scan(/\[.+\]/)[0]
    text = el.value.scan(/\{[^\}]+\}/)[0]
    title = title.gsub(/[\[\]"]/, "")
    text = text.gsub(/[{}"]/, "")
    '<div class="foreign sortable"><div class="title">'+title+'</div><div class="translation">('+text+')</div></div>'
  end
  def convert_cite(el, indent)
    key = el.value.scan(/\[.+\]/)[0]
    quote = el.value.scan(/\{[^\}]+\}/)[0]
    key = key.gsub(/[\[\]"]/, "")
    quote = quote.gsub(/[{}"]/, "")
    quote = Kramdown::Converter::FP_Html.convert(Kramdown::Document.new(quote, :input => "FP_Markdown").root)[0]
    citation = "BibTeX-Key not found!"
    begin
      Dir.foreach(FassetsPresentations::Engine.root.to_s+'/app/bibtex/') do |file|
        begin
          unless file == "." or file == ".."
            b = BibTeX.open(FassetsPresentations::Engine.root.to_s+'/app/bibtex/'+file)
            citation = b[key].author.to_s+" ("+b[key].year.to_s+")"
          end
        rescue Exception => ex
          puts ex
        end
      end
    rescue Exception => ex
      puts ex
    end
    '<div class="cite sortable"><div class="quote">'+quote+'</div><div class="citation" id="'+key+'">'+citation+'</div></div>'
  end
end
