module XSS
  class Translator
    N = XSS::Nodes

    def initialize(xss_document)
      @xss_document = xss_document
      @translated_rules = []
    end

    def translate()
      @xss_document.statements.each do |statement|
        translate_statement(statement)
      end

      css_document
    end

    protected
      def css_document
        css_document = N::Document.new()
        css_document.statements = @translated_rules

        css_document
      end

      def translate_statement(statement)
        case statement
        when N::RuleSet
          translate_rule_set(statement)
        when N::Property
          translate_property(statement)
        when N::GroupedProperty
          translate_grouped_property(statement)
        when N::EmptyStatement
          # do nothing
        else
          raise "unhandled statement #{statement.class}"
        end
      end

      def translate_rule_set(xss)
        selector_group = if @current_rule
          @current_rule.selector_group.product(xss.selector_group).map do |parent, child|
            child.items.first.combinator = ' ' if child.items.first.combinator == nil # TODO: move this to parser reducing or pre-translating
            N::Selector.new(:items => (parent.items + child.items))
          end
        else
          xss.selector_group.dup
        end
        rule = N::RuleSet.new(:selector_group => selector_group, :body => N::RuleSetBody.new(:statements => []))
        @translated_rules << rule
        
        old_last_rule = @current_rule
        @current_rule = rule
        @property_name_prefix = ''

        xss.body.statements.each do |statement|
          translate_statement(statement)
        end

        @current_rule = old_last_rule
      end

      def translate_property(xss)
        css = N::Property.new
        css.name = @property_name_prefix + xss.name
        css.value = xss.value

        @current_rule.body.statements << css
      end

      def translate_grouped_property(xss)
        old_property_name_prefix = @property_name_prefix
        @property_name_prefix = "#{@property_name_prefix}#{xss.name}-"

        xss.body.statements.each do |statement|
          translate_statement(statement)
        end

        @property_name_prefix = old_property_name_prefix
      end
  end
end
