module XSS
  # supported token types: :IDENT, :NUMBER, :LENGTH, :SPACE

  class Lexer
    class Token
      attr_accessor :type, :value, :line, :pos

      def initialize(type, value = nil, line = nil, pos = nil)
        self.type = type
        if value == nil && type.kind_of?(String)
          self.value = type
        else
          self.value = value
        end
      end
    end

    class SymbolToken < Token
    end

    def initialize(input)
      @scanner = StringScanner.new(input)
      @buf = []
    end

    def next_token
      return @buf.shift if @buf.any?

      return nil if @scanner.eos?
      # skip_comment
      next_char = @scanner.peek(2)
      case next_char
      when '~=', '|=', '^=', '$=', '*='
        @scanner.pos = @scanner.pos + 2
        return SymbolToken.new(next_char)
      end
      
      next_char = @scanner.peek(1)
      case next_char 
      when '#', '.', '*', '[', ']', '{', '}', ':', ';', ',', '>', '+', '=', '~'
        @scanner.pos = @scanner.pos + 1
        return Token.new(next_char)
      end

      space = next_space
      if space
        next_char = @scanner.peek(1)
        if next_char == ':' || next_char == '{' || next_char == ','
          @scanner.pos = @scanner.pos + 1
          return Token.new(next_char)
        end
        return space
      else
        return next_ident
      end
      
      
    end

    private
      def next_ident
        value = @scanner.scan(/[\-a-zA-Z0-9_]+/)
        Token.new(:IDENT, value) if value != nil
      end

      def next_space
        value = @scanner.scan(/[ \n\r]+/)
        Token.new(:SPACE, value) if value != nil
      end

      def skip_comment
        # @scanner.
      end
  end
end
