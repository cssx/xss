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
      
      def serialize_property(property)
        rule_set = parse_rule_set('div {}')
        rule_set.body.statements = [property]
        css = serialize_rule_set(rule_set)
        css.should match(/^div\{.*\}$/)

        css[4..-2]
      end
    end
  end
end
