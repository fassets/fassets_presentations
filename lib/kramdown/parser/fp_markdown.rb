require "kramdown/parser/kramdown"

class Kramdown::Parser::FP_Markdown < Kramdown::Parser::Kramdown
  def initialize(source, options) # :nodoc:
    super
    @span_parsers.unshift(:definition)
    @span_parsers.unshift(:example)
    @span_parsers.unshift(:box)
    @span_parsers.unshift(:foreign)
  end
  DEFINITION_START = /\\definition/
  DEFINITION_MATCH = /\[(.|\n)+\]\{(.|\n)+\}/
  def parse_definition
    @src.pos += @src.matched_size
    title,text = @src.scan(DEFINITION_MATCH)
    el = Element.new(:definition,title,text)
    @tree.children << el
  end
  define_parser(:definition,DEFINITION_START)
  
  EXAMPLE_START = /\\example/
  EXAMPLE_MATCH = /\[(.|\n)+\]\{(.|\n)+\}/
  def parse_example
    @src.pos += @src.matched_size
    title,text = @src.scan(EXAMPLE_MATCH)
    el = Element.new(:example,title,text)
    @tree.children << el
  end
  define_parser(:example,EXAMPLE_START)

  BOX_START = /\\box/
  BOX_MATCH = /\[(.|\n)+\]\{(.|\n)+\}/
  def parse_box
    @src.pos += @src.matched_size
    title,text = @src.scan(BOX_MATCH)
    el = Element.new(:box,title,text)
    @tree.children << el
  end
  define_parser(:box,BOX_START)
  
  FOREIGN_START = /\\foreign/
  FOREIGN_MATCH = /\[.+\]\{.+\}/
  def parse_foreign
    @src.pos += @src.matched_size
    title,text = @src.scan(FOREIGN_MATCH)
    el = Element.new(:foreign,title,text)
    @tree.children << el
  end
  define_parser(:foreign,FOREIGN_START)
end
