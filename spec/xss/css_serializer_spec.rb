require 'spec_helper'

describe XSS::CSSSerializer do
  include XSS::Rspec::SerializerHelper
  include XSS::Rspec::ParserHelper

  it 'should serialize document with statements' do
    rule_set1 = parse_rule_set('div {}')
    rule_set2 = parse_rule_set('#a {}')
    doc = N::Document.new(:statements => [rule_set1, rule_set2])
    serialize_document(doc).should == 'div{}#a{}'
  end

  it 'should serialize rule_set' do
    rule_set = parse_rule_set('div, a { color: red; text-align: center}')
    serialize_rule_set(rule_set).should == 'div,a{color:red;text-align:center;}'
  end

  it 'should serialize property with number' do
    property = parse_property('top: 1px;')
    serialize_property(property).should == 'top:1px;'
  end

  it 'should serialize selector with combinators' do
    selector = parse_selector('a b > c ~ d + e')
    serialize_selector(selector).should == 'a b>c~d+e'
  end

  it 'should serialize simple_selector with multiple items' do
    selector = parse_selector('div.clazz#id[name=value]')
    serialize_selector(selector).should == 'div.clazz#id[name=value]'
  end
end
