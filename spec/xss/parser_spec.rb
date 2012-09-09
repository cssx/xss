require 'spec_helper'
# require 'yaml'

describe XSS::Parser do
  include XSS::Rspec::ParserHelper
  
  describe "document" do
    it "should parse document to statements" do
      document = parse("div {}\n a { } ")
      document.should be_a(N::Document)
      document.statements.should have(2).items
      document.statements[0].should be_a(N::RuleSet)
      document.statements[1].should be_a(N::RuleSet)
    end
  end
  
  describe "rule_set" do
    it "should parse rule_set" do
      rule_set = parse_rule_set("div {}")
      rule_set.should be_a(N::RuleSet)
      rule_set.selector_group.should be_a(Enumerable)
      rule_set.body.should be_a(N::RuleSetBody)
    end
    
    it "should parse selector_group" do
      rule_set = parse_rule_set("div, a , b {}")
      rule_set.selector_group.should have(3).items
      (0..2).each { |i| rule_set.selector_group[i].should be_a(N::Selector) }
    end
  end

  describe "rule_set", "rule_set_body" do
    it "should parse rule set body's statements" do
      body = parse_rule_set_body('{ }')
      body.should_not be_nil
    end
    
    it "should parse properties" do
      body = parse_rule_set_body('{ color: red; font :arial ; }')
      body.statements.should have(2).items
      body.statements[0].should be_a(N::Property)
      body.statements[1].should be_a(N::Property)
    end
    
    it "should parse latest property missing semicolon" do
      body = parse_rule_set_body('{ color: red; font :arial }')
      body.statements.should have(2).items
      body.statements[0].should be_a(N::Property)
      body.statements[1].should be_a(N::Property)
    end
    
    it "should parse empty statement" do
      body = parse_rule_set_body('{ color: red; ; font: arial; }')
      body.statements.should have(3).items
      body.statements[0].should be_a(N::Property)
      body.statements[1].should be_a(N::EmptyStatement)
      body.statements[2].should be_a(N::Property)
    end
    
    it "should parse grouped-property" do
      body = parse_rule_set_body('{ color: red; font: { family: arial; } padding: auto; }')
      body.statements.should have(3).items
      body.statements[0].should be_a(N::Property)
      body.statements[1].should be_a(N::GroupedProperty)
      body.statements[2].should be_a(N::Property)
    end
    
    it "should parse nested rule set" do
      body = parse_rule_set_body('{ color: red; a { font: arial; } padding: auto; }')
      body.statements.should have(3).items
      body.statements[0].should be_a(N::Property)
      body.statements[1].should be_a(N::RuleSet)
      body.statements[2].should be_a(N::Property)
    end
  end
end
