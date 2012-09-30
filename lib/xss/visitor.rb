module XSS
  class Visitor
    protected
      def visit(node)
        custom_visit_method = "visit_#{node.node_name}"
        return send(custom_visit_method, node) if respond_to?(custom_visit_method)

        node.class.attributes.each do |attr_name|
          attr_value = node.send(attr_name)
          if attr_value.kind_of?(XSS::Nodes::AbstractNode)
            visit(attr_value)
          elsif attr_value.respond_to?(:each)
            attr_value.each do |item|
              visit(item) if item.kind_of?(XSS::Nodes::AbstractNode)
            end
          end
        end
      end
  end
end
