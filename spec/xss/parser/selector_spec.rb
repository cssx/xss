require 'spec_helper'

describe XSS::Parser, "selector" do
  include XSS::Rspec::ParserHelper
  N = XSS::Nodes
  
  context "general" do
    it "should parse selector" do
      selector = parse_selector("div ")
      selector.should be_a(N::Selector)
    end
    
    it "should parse multiple selector items" do
      selector = parse_selector("div a b")
      selector.items.should have(3).items
      (0..2).each do |i| 
        selector.items[i].should be_a(N::SelectorItem)
        selector.items[i].simple_selector.should be_a(N::SimpleSelector)
      end
    end
    
    it "should parse multiple selector items with combinators" do
      selector = parse_selector("div a > b + c ~ d")
      selector.items.should have(5).items
      selector.items[0].combinator.should == nil
      selector.items[1].combinator.should == ' '
      selector.items[2].combinator.should == '>'
      selector.items[3].combinator.should == '+'
      selector.items[4].combinator.should == '~'
    end
  
    it "should parse multiple selector item combinators with different spaces" do
      selector = parse_selector("a > b> c >d>e  ")
      selector.items.should have(5).items
      (1..4).each do |i|
        selector.items[i].combinator.should == '>'
      end
    end
  end
  
  describe "simple_selector" do
    # TODO: namespace, psuedo selector
    it "should parse simple_selector" do
      simple_selector = parse_simple_selector('div.clazz#id')
      simple_selector.should be_a(N::SimpleSelector)
      simple_selector.items.should == ['div', '.clazz', '#id']
    end
  end
  
  describe "simple_selector", "universal_selector" do
    it "should parse universal_selector" do
      simple_selector = parse_simple_selector('*')
      simple_selector.should be_a(N::SimpleSelector)
      simple_selector.items.should == ['*']
    end
  end
  
  describe "simple_selector", "attribute_selector" do
    # TODO: namespace, string-quoted attribute_value
    it "should parse attribute_selector without value" do
      simple_selector = parse_simple_selector('[attribute-name]')
      simple_selector.should be_a(N::SimpleSelector)
      simple_selector.items.should == ['[attribute-name]']
    end
    
    it "should parse attribute_selector with value" do
      ['=', '~=', '|=', '^=', '$=', '*='].each do |operator|
        simple_selector = parse_simple_selector("[attribute-name#{operator}attr-value]")
        simple_selector.should be_a(N::SimpleSelector)
        simple_selector.items.should == ["[attribute-name#{operator}attr-value]"]
      end
    end
    
    # it "should parse attribute_selector with string-quoted value", :pending do
    #   simple_selector = parse_simple_selector("[attribute-name='attr-value']")
    #   simple_selector.should be_a(N::SimpleSelector)
    #   simple_selector.items.should == ["[attribute-name='attr-value']"]
    # end
  end
end
