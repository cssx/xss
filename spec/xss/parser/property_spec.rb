require 'spec_helper'

describe XSS::Parser, "selector" do
  include XSS::Rspec::ParserHelper

  it 'should parse property name as value' do
    property = parse_property('color: red')
    property.should be_a(N::Property)
    property.name.should == 'color'
    property.value.should == 'red'
  end

  it 'should parse property with number as value' do
    property = parse_property('top: 123')
    property.value.should == V::Number.new(123)
  end
end
