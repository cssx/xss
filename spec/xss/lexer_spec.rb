require 'spec_helper'

describe XSS::Lexer do
  def parse_tokens(source)
    lexer = XSS::Lexer.new(source)
    tokens = []
    while token = lexer.next_token
      tokens << token
    end
    tokens.map do |token|
      case token.type
      when :SPACE, String
        token.type
      else
        [token.type, token.value]
      end
    end
  end

  it 'should parse tokens' do
    parse_tokens('div').should == [[:IDENT, 'div']]
    parse_tokens('  div     a  ').should == [:SPACE, [:IDENT, 'div'], :SPACE, [:IDENT, 'a'], :SPACE]
    parse_tokens(%q{div.some-class#some-id{ a: b;}}).should == [[:IDENT, 'div'], '.', [:IDENT, 'some-class'],
      '#', [:IDENT, 'some-id'], '{', :SPACE, [:IDENT, 'a'], ':', :SPACE, [:IDENT, 'b'], ';', '}'
    ]
    parse_tokens(%q{div{top:10}}).should == [[:IDENT, 'div'], '{', [:IDENT, 'top'], ':', [:NUMBER, "10"], '}']
  end

  it 'should combine space token and symbol token' do
    parse_tokens('a , b { color : red } ').should == [[:IDENT, 'a'], ',', :SPACE, [:IDENT, 'b'], '{', :SPACE, [:IDENT, 'color'], ':', :SPACE, [:IDENT, 'red'], :SPACE, '}', :SPACE]
  end

  # it 'should skip comment'
  # it 'should skip last bad comment'
end
