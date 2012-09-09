module XSS
  module Rspec
    module SerializerHelper
      def serialize_document(document)
        serializer = XSS::CSSSerializer.new(document)
        css = serializer.serialize

        css
      end
  
      def serialize_rule_set(rule_set)
        document = N::Document.new(:statements => [rule_set])
        serialize_document(document)
      end
  
      def serialize_selector(selector)
        rule_set = N::RuleSet.new(:selector_group => [selector], :body => N::RuleSetBody.new(:statements => []))
        css = serialize_rule_set(rule_set)
        css[-2..-1].should == '{}'

        css[0...-2]
      end
      
      # def parse_simple_selector(source)
      #   selector = parse_selector(source)
      #   selector.items.should have(1).item
        
      #   selector.items.first.simple_selector
      # end
      
      # def parse_rule_set_body(source)
      #   rule_set = parse_rule_set("div #{source}")
      #   rule_set.body
      # end
    end
  end
end
