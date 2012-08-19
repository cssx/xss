# require 'xss/generated_parser'
require 'xss/lexer'
require 'xss/nodes'
require 'racc'

module XSS
  grammar = Racc::Grammar.define do
    self.document = many(:rule_set) do |statements| 
      node(:document, :statements => statements)
    end
    self.os = option(:SPACE)
    # FIXME: not completed
    self.name = seq(:IDENT)
    
    # FIXME: not completed
    # self.string = seq("'", many(:IDENT) , "'") { |_, value, _| value.join() }
    
    self.rule_set = seq(:selector_group, :rule_set_body) do |selector_group, rule_set_body|
      node(:rule_set, :selector_group => selector_group, :body => rule_set_body)
    end
    self.selector_group = separated_by(:selector_separator, :selector)
    self.selector_separator = seq(',', :os)
    self.selector = seq(:simple_selector, many(:selector_item), :os) do |first_simple_selector, rest_items, _|
      first_item = node(:selector_item, :simple_selector => first_simple_selector)
      node(:selector, :items => rest_items.unshift(first_item))
    end
    self.selector_item = seq(:selector_combinator, :simple_selector) do |combinator, simple_selector|
      node(:selector_item, :combinator => combinator, :simple_selector => simple_selector)
    end
    self.selector_combinator = seq(:os, '>', :os) { |_, _, _| '>' } | # child combinator
                               seq(:os, '+', :os) { |_, _, _| '+' } | # adjacent sibling combinator
                               seq(:os, '~', :os) { |_, _, _| '~' } | # general sibling combinator
                               seq(:SPACE) { |_| ' ' }        # descendant combinator
    
    self.simple_selector = many1(:simple_selector_item) do |items|
      node(:simple_selector, :items => items)
    end
    self.simple_selector_item = seq(:type_selector) | seq(:class_selector) | seq(:id_selector) |  
                                seq(:psuedo_selector) | seq(:universal_selector) | seq(:attribute_selector)
    self.type_selector = seq(:name) do |element_name|
      element_name
    end
    self.class_selector = seq('.', :name) do |_, class_name|
      ".#{class_name}"
    end
    self.id_selector = seq('#', :name) do |_, identifer|
      "##{identifer}"
    end
    self.universal_selector = seq('*')
    self.attribute_selector = seq('[', :os, :name, :os, ']') { |_, _, name, _, _| "[#{name}]" } |
                              seq('[', :os, :name, :os, :attribute_selector_operator, :os, :attribute_selector_value, ']') do |_, _, name, _, operator, _, value, _|
                                "[#{name}#{operator}#{value}]"
                              end
    self.attribute_selector_operator = seq('=')  | # equal
                                       seq('~=') | # includes
                                       seq('|=') | # dash match
                                       seq('^=') | # prefix match
                                       seq('$=') | # suffix match
                                       seq('*=')   # substring match
    
    self.attribute_selector_value = seq(:name)
    
    self.rule_set_body = seq('{', :os, '}', :os) do |_, _, _, _|
      node(:rule_set_body)
    end
  end
  
  Parser = grammar.parser_class
  class Parser
    def initialize(source)
      @lexer = Lexer.new(source)
    end
    
    def parse
      do_parse
    end
    
    protected
      def next_token
        token = @lexer.next_token
        return nil if token == nil

        [token.type, token.value]
      end

      def node(type, options = {})
        node_class = type.kind_of?(Class) ? type : XSS::Nodes.const_get(type.to_s.split('_').map{ |p| p.capitalize }.join)
        node = node_class.new
        options.each do |name, value|
          node.send("#{name}=", value)
        end

        node
      end
  end
end
