require 'xss/visitor'

module XSS
  class Translator < Visitor
    def initialize(xss_document)
      @xss_document = xss_document
      @translated_rules = []
    end

    def translate()
      visit(@xss_document)
      build_css_document
    end

    protected
      def build_css_document
        css_document = N::Document.new()
        css_document.statements = @translated_rules

        css_document
      end

      def visit_rule_set(xss)
        css_selector_group = if @current_rule
          @current_rule.selector_group.product(xss.selector_group).map do |parent, child|
            child.items.first.combinator = ' ' if child.items.first.combinator == nil # TODO: move this to parser reducing or pre-translating
            N::Selector.new(:items => (parent.items + child.items))
          end
        else
          xss.selector_group.dup # TODO use deep-clone
        end
        rule = N::RuleSet.new(:selector_group => css_selector_group, :body => N::RuleSetBody.new(:statements => []))
        @translated_rules << rule
        
        saved_current_rule = @current_rule
        @current_rule = rule
        @property_name_prefix = ''
        visit(xss.body)
        @current_rule = saved_current_rule

      end

      def visit_property(xss)
        css = N::Property.new
        css.name = @property_name_prefix + xss.name
        css.value = xss.value

        @current_rule.body.statements << css
      end

      def visit_grouped_property(xss)
        save_property_name_prefix = @property_name_prefix
        @property_name_prefix = "#{@property_name_prefix}#{xss.name}-"
        visit(xss.body)
        @property_name_prefix = save_property_name_prefix
      end
  end
end
