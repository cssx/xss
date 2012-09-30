require 'spec_helper'
require 'xss/visitor'

describe XSS::Visitor do
  include XSS::Rspec::ParserHelper

  class TestVisitor < XSS::Visitor
    def travel(document)
      @visited_nodes = []
      visit(document)
      @visited_nodes
    end

    def visit(node)
      @visited_nodes << node
      super
    end
  end

  class TestVisitor2 < XSS::Visitor
    def travel(document)
      @visited_property = nil
      visit(document)
      @visited_property
    end

    def visit_property(node)
      @visited_property = node
    end
  end

  it 'should travle all nodes' do
    visitor = TestVisitor.new
    document = parse('a, b.c { x : y }')
    visited_nodes = visitor.travel(document)

    rule_set = document.statements.first

    visited_nodes.should include(document)
    visited_nodes.should include(rule_set)
    visited_nodes.should include(rule_set.selector_group[0])
    visited_nodes.should include(rule_set.selector_group[1])
    visited_nodes.should include(rule_set.body)
    visited_nodes.should include(rule_set.body.statements.first)
  end

  it 'should use delegate to custom method' do
    visitor = TestVisitor2.new
    document = parse('a, b.c { x : y }')
    visited_property = visitor.travel(document)
    visited_property.should == document.statements.first.body.statements.first
  end
end
