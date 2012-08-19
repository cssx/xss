module XSS
  module Rspec
    module ParserHelper
      # def node(type, options = {})
      #   node_class = XSS::Nodes.const_get(type.to_s.split('_').map{ |p| p.capitalize }.join)
      #   node = node_class.new
      #   options.each do |name, value|
      #     node.send("#{name}=", value)
      #   end
      # 
      #   node
      # end
      # 
      # def y(object)
      #   puts object.to_yaml
      # end

      def parse(source)
        parser = XSS::Parser.new(source)
        parser.parse
      end
  
      def parse_rule_set(source)
        document = parse(source)
        document.statements.should have(1).item
      
        document.statements.first
      end
  
      def parse_selector(source)
        rule_set = parse_rule_set(source + "{}")
        rule_set.selector_group.should have(1).item
    
        rule_set.selector_group.first
      end
      
      def parse_simple_selector(source)
        selector = parse_selector(source)
        selector.items.should have(1).item
        
        selector.items.first.simple_selector
      end
    end
  end
end