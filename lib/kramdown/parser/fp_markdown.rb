require "kramdown/parser/kramdown"

class Kramdown::Parser::FP_Markdown < Kramdown::Parser::Kramdown
  def initialize(source, options) # :nodoc:
    super
    @block_parsers.unshift(:definition)
    @block_parsers.unshift(:example)
    @block_parsers.unshift(:box)
    @block_parsers.unshift(:foreign)
    @block_parsers.unshift(:cite)
  end
  DEFINITION_START = /\\definition/
  DEFINITION_MATCH = /\[(.*?)\]\{(.*?)\}/m
  def parse_definition
    @src.pos += @src.matched_size
    result = @src.scan(DEFINITION_MATCH)
    el = Element.new(:definition,result)
    @tree.children << el
  end
  define_parser(:definition,DEFINITION_START)
  
  EXAMPLE_START = /\\example/
  EXAMPLE_MATCH = /\[(.*?)\]\{(.*?)\}/m
  def parse_example
    @src.pos += @src.matched_size
    result = @src.scan(DEFINITION_MATCH)
    el = Element.new(:example,result)
    @tree.children << el
  end
  define_parser(:example,EXAMPLE_START)

  BOX_START = /\\box/
  BOX_MATCH = /\[(.*?)\]\{(.*?)\}/m
  def parse_box
    @src.pos += @src.matched_size
    result = @src.scan(BOX_MATCH)
    el = Element.new(:box,result)
    @tree.children << el
  end
  define_parser(:box,BOX_START)
  
  FOREIGN_START = /\\foreign/
  FOREIGN_MATCH = /\[(.*?)\]\{(.*?)\}/m
  def parse_foreign
    @src.pos += @src.matched_size
    result = @src.scan(FOREIGN_MATCH)
    el = Element.new(:foreign,result)
    @tree.children << el
  end
  define_parser(:foreign,FOREIGN_START)

  CITE_START = /\\cite/
  CITE_MATCH = /\[(.*?)\]\{(.*?)\}/m
  def parse_cite
    @src.pos += @src.matched_size
    result = @src.scan(CITE_MATCH)
    el = Element.new(:cite,result)
    @tree.children << el
  end
  define_parser(:cite,CITE_START)
end
