module XSS
  class CSSSerializer
    N = XSS::Nodes

    def initialize(document)
      @document = document
      @buf = []
    end

    def serialize()
      serialize_document(@document)
      @buf.join()
    end

    protected

      def serialize_document(document)
        document.statements.each do |statement|
          serialize_statement(statement)
        end
      end

      def serialize_statement(statement)
        case statement
        when N::RuleSet
          serialize_rule_set(statement)
        end
      end

      def serialize_rule_set(rule_set)
        is_first = true
        rule_set.selector_group.each do |selector|
          @buf << ',' unless is_first
          serialize_selector(selector)
          is_first = false
        end
        
        @buf << '{'

        rule_set.body.statements.each do |property|
          serialize_property(property)
        end

        @buf << '}'
      end

      def serialize_selector(selector)
        selector.items.each do |item|
          @buf << item.combinator if item.combinator
          item.simple_selector.items.each do |element|
            @buf << element
          end
        end
      end

      def serialize_property(property)
        @buf << property.name
        @buf << ':'
        @buf << property.value.to_s
        @buf << ';'
      end
  end
end
