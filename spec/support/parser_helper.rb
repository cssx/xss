module XSS
  module Rspec
    module ParserHelper
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
      
      def parse_rule_set_body(source)
        rule_set = parse_rule_set("div #{source}")
        rule_set.body
      end

      def parse_property(source)
        body = parse_rule_set_body("{#{source}}")
        body.statements.should have(1).item
        
        body.statements.first
      end
    end
  end
end