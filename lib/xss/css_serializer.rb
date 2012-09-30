require 'xss/visitor'

module XSS
  class CSSSerializer < Visitor
    def initialize(document)
      @document = document
      @buf = []
    end

    def serialize()
      visit(@document)
      @buf.join()
    end

    protected
      def visit_rule_set(rule_set)
        is_first = true
        rule_set.selector_group.each do |selector|
          @buf << ',' unless is_first
          visit(selector)
          is_first = false
        end
        visit(rule_set.body)
      end

      def visit_selector_item(selector_item)
        @buf << selector_item.combinator if selector_item.combinator
        visit(selector_item.simple_selector)
      end

      def visit_simple_selector(simple_selector)
        simple_selector.items.each do |element|
          @buf << element
        end
      end

      def visit_rule_set_body(body)
        @buf << '{'
        body.statements.each do |statement|
          visit(statement)
        end
        @buf << '}'
      end

      def visit_property(property)
        @buf << property.name
        @buf << ':'
        @buf << property.value.to_s
        @buf << ';'
      end
  end
end
