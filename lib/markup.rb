module Markup
  class Node
    def initialize
      @children = [] 
    end
    def <<(node) 
      @children << node
      self
    end
    def to_html
      content_to_html
    end
    def content_to_html
      @children.inject("") do |s, c| 
        s << c.to_html
      end
    end
    def last_child
      @children.last
    end
  end

  class Plain
    def initialize(text)
      @text = text
    end
    def to_html
      @text
    end
  end
  class Break
    def to_html
      "<br />"
    end
  end

  class EnclosingTag
    attr_writer :css_class
    def css_class
      @css_class ? "class=\"#{@css_class}\"" : ""
    end
  end
  class Emphasis < EnclosingTag
    def initialize(text)
      @text = text
    end
    def to_html
      "<em #{css_class}>" + @text + "</em>"
    end
  end

  class Link < EnclosingTag
    def initialize(title, url)
      @title = title
      @url = url
    end
    def to_html
      '<a href="' + @url + '" #{css_class}>' + @title + '</a>'
    end
  end

  class Block < Node
    def initialize(tag)
      super()
      @tag = tag.to_s
    end
    def tag
      @tag
    end
    def to_html
      "<#{@tag}>" + content_to_html + "</#{@tag}>"
    end
  end
  class Code < Node
    def initialize(code)
      super()
      @code = code
    end
    def to_html
      "<pre><code>" + @code + "</code></pre>"
    end
  end
  class Container < Node
    def initialize(title)
      super()
      @title = title
    end
    def to_html
      %Q{
        <div class="container">
          <div class="title">#{@title}</div>
          <div class="content">#{content_to_html}</div>
        </div>
      }
    end
  end

  class InlineParser
    def initialize(input)
      @input = input
      @pos = 0
      @inline = Node.new
    end
    def parse
      while(@pos < @input.size) do
        case @input[@pos, 1]
        when "\n"
          @inline << Break.new
          @pos += 1
        when "["
          parse_emphasis_or_link
        else
          parse_plain
        end
      end
      return @inline
    end
  private
    def parse_plain
      plain_end =  @input.index(/(\n|_(\S.*\S|\S+)_|\[.*\|.*\])/, @pos + 1) || @input.size
      @inline << Plain.new(@input[@pos..plain_end-1])
      @pos = plain_end
    end
    def parse_emphasis_or_link
      token_end = @input.index("]", @pos + 1)
      if token_end
        title_end = @input.index("|", @pos + 1)
        token = nil
        if title_end && title_end < token_end
          token = Link.new(@input[@pos + 1..title_end-1], @input[title_end + 1..token_end-1])
        else
          token = Emphasis.new(@input[@pos + 1..token_end-1])
        end
        if @input.index(/:(\w+)/) == token_end + 1
          token.css_class = $1
          @pos = token_end + 2 + $1.size
        else
          @pos = token_end + 1
        end
        @inline << token
      else
        parse_plain
      end
    end
  end
  class BlockParser
    def initialize(input)
      @input = input
      @pos = 0
      @doc = Node.new
    end
    def parse(containers=true)
      while(@pos < @input.size) do
        case @input[@pos, 1]
        when /[ \t\n]/ 
          @pos += 1    #skip whitespace
        when /[*#]/
          parse_list(@input[@pos, 1])
        when '$'
          parse_code 
        when '&'
          if containers
            parse_container
          else
            parse_paragraph
          end
        else
          parse_paragraph
        end
      end
      return @doc
    end
  private
    def current_char
      @input[@pos, 1]
    end
    def parse_paragraph
      para_end = @input.index(/\n[ \t]*(\n|\*|\#|\&|\$)/, @pos) || @input.size + 1
      @doc << (Block.new(:p) << InlineParser.new(@input[@pos..para_end]).parse)
      @pos = para_end
    end
    def parse_list(bullet)
      stack = []
      while true do
        puts @input[@pos..@input.size + 1]
        puts "-----------"
        next_item = @input.index(/\n(\*|#)/,  @pos)
        list_end = @input.index(/\n[ \t]*(&|\$|\w|\n)/,  @pos) || @input.size + 1
        puts "nxt itm:#{next_item}"
        puts "lst end:#{list_end}"        
        inline_end = [next_item || @input.size + 1, list_end].min
        line = @input[@pos..inline_end]

        bullet = line[0,1]
        bullet_level = line.index(bullet == "*" ? /[^\*]/ : /[^#]/) || 1
        if bullet_level > stack.size
          sublist = Block.new(bullet == '*' ? :ul : :ol)
          stack.last.last_child << sublist unless stack.empty?
          stack << sublist
        end
        if bullet_level < stack.size
          (stack.size - bullet_level).times{stack.pop}
        end
        stack.last << (Block.new(:li) << InlineParser.new(line[bullet_level..line.size]).parse)
        if next_item && next_item < list_end
          @pos = next_item + 1
        else
          @pos = list_end
          break
        end
      end
      @doc << stack.first
    end

    def parse_code
      code_end = @input.index("$",  @pos + 1) || @input.size + 1
      @doc << Code.new(@input[@pos + 1..code_end - 1])
      @pos = code_end + 1
    end
    def parse_container
      title_end = @input.index("{",  @pos + 1)
      if title_end
        content_end = @input.index("}",  title_end) || @input.size + 1
        content = parse_container_content(@input[title_end + 1..content_end-1])
        @doc << (Container.new(@input[@pos + 1..title_end - 1]) << content)
        @pos = content_end + 1
        return
      else
        parse_paragraph
      end
    end
    def parse_container_content(content)
      prev_input = @input
      prev_doc = @doc
      prev_pos = @pos
      @input = content
      @doc = Node.new
      @pos = 0
      doc = parse(false)
      @input = prev_input
      @doc = prev_doc
      @pos = prev_pos
      return doc
    end
  end 
  
  
  def Markup.to_html(input)
    BlockParser.new(input.gsub(/\r\n/, "\n")).parse.to_html
  end
end


test = "*a\n&b{\n*c}"
puts Markup.to_html(test)
