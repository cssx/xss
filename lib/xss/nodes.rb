module XSS
  module Nodes
    class AbstractNode

      def self.inherited(clazz)
        clazz.class_eval do
          @_attrs = []

          def self.attr(name)
            attr_accessor name
            @_attrs << name
          end

          def self.node_name
            name.split('::').last.gsub(/[A-Z]/){ |c| "_#{c.downcase}" }[1..-1]
          end

          def self.attributes
            @_attrs
          end
        end
      end

      def initialize(options = {})
        options.each do |name, value|
          self.send("#{name}=", value)
        end
      end

      def ==(other)
        other.class == self.class && self.class.instance_variable_get('@_attrs').all?{ |attr| other.send(attr) == self.send(attr)}
      end

      def node_name
        self.class.node_name
      end
    end
    
    class Document < AbstractNode
      attr :statements
    end

    class RuleSet < AbstractNode
      attr :selector_group
      attr :body
    end

    class Selector < AbstractNode
      attr :items
    end
    
    class SelectorItem < AbstractNode
      attr :simple_selector
      attr :combinator      
    end
    
    class SimpleSelector < AbstractNode
      attr :items
    end

    class RuleSetBody < AbstractNode
      attr :statements
    end
    
    class EmptyStatement < AbstractNode
    end
    
    class Property < AbstractNode
      attr :name
      attr :value
    end
    
    class GroupedProperty < AbstractNode
      attr :name
      attr :body
    end
  end
end
