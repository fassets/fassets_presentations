module FassetsPresentations
  module FramesHelper
    def to_fp_html(str)
      Kramdown::Converter::FP_Html.convert(Kramdown::Document.new(str, :input => "FP_Markdown").root)[0].html_safe
    end
    def to_fp_markdown(str)
      Kramdown::Converter::FP_Markdown.convert(Kramdown::Document.new(str).root)[0]
    end
    def html_to_markdown(str)
      Kramdown::Converter::FP_Markdown.convert(Kramdown::Document.new(str, :input => "FP_Html").root)[0]
    end
  end
end
