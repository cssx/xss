require 'spec_helper'

describe XSS::Translator do
  include XSS::Rspec::SerializerHelper
  include XSS::Rspec::ParserHelper

  def translate(xss_source)
    xss_document = parse(xss_source)
    translator = XSS::Translator.new(xss_document)
    css_document = translator.translate()
    css = serialize_document(css_document)

    css
  end

  context 'document' do
    it 'should translate empty xss document to empty css document' do
      translate('').should == ''
    end
  end

  context 'single rule_set' do
    it 'should translate single empty rule_set' do
      translate('a,b {}').should == 'a,b{}'
    end

    it 'should translate properties' do
      translate('a { color: red; text-algin: center }').should == 'a{color:red;text-algin:center;}'
    end

    it 'should ignore empty statement' do
      translate('a { color: red;;;}').should == 'a{color:red;}'
    end
  end

  context 'grouped property' do
    it 'should translate grouped property' do
      translate('a { color: red; font: { family: arial; style: italic; }}').should == 'a{color:red;font-family:arial;font-style:italic;}'
    end

    it 'should translate 2-level grouped property' do
      translate('div { a1: { b1: { c1: x } b2: y } a2: z}').should == 'div{a1-b1-c1:x;a1-b2:y;a2:z;}'
    end

    it 'should translate 2 grouped properties' do
      translate('div { a1: { b1: x; b2: y } a2: { b3: z}; a2: t }').should == 'div{a1-b1:x;a1-b2:y;a2-b3:z;a2:t;}'
    end
  end

  context 'nested rule_set' do
    it 'should translate nested rule_set' do
      translate('s1 { a1: x; p1 { b1: y } a2: z}').should == 's1{a1:x;a2:z;}s1 p1{b1:y;}'
    end

    it 'should translate nested rule_set with selector_group' do
      translate('s1, s2 { a1: x; p1, p2 { b1: y } }').should == 's1,s2{a1:x;}s1 p1,s1 p2,s2 p1,s2 p2{b1:y;}'
    end

    it 'should translate 2-level nested rule_set' do
      translate('s1 { a1:x; p1,p2 { b1: y; q1 { c1: z } } } ').should == 
        's1{a1:x;}s1 p1,s1 p2{b1:y;}s1 p1 q1,s1 p2 q1{c1:z;}'
    end

    it 'should translate 2 nested rule_set' do
      translate('s1 { a1:x; p1 { b1: y} p2 { b2: z } } ').should == 
        's1{a1:x;}s1 p1{b1:y;}s1 p2{b2:z;}'
    end
  end
end
