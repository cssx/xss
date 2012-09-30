module XSS
  module Values

    # TODO: update to support various formats
    class Color
      attr_accessor :data

      def initialize(string_value)
        @data = string_value
      end
    end

    class Number
      attr_accessor :value
      attr_accessor :unit # nil, :%, :em, :px, :cm, :pt

      def initialize(value, unit = nil)
        @value = value
        @unit = unit
      end

      def ==(other)
        other.kind_of?(Number) && self.value == other.value && self.unit == other.unit
      end
    end
  end
end
