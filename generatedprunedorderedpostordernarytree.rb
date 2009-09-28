=begin
Author: Mark D. Blackwell
Date created: April 24, 2009.
Date last changed: May 11, 2009.
Copyright (c) 2009 Mark D. Blackwell.

Name: Generated, pruned, post-order, ordered, n-ary tree.
File: generatedprunedorderedpostordernarytree.rb
Usage: require 'generatedprunedorderedpostordernarytree'

A virtual tree, using depth-first traversal; only a single branch exists at any time. The 
module, GeneratedPrunedOrderedPostOrderNaryTreeExample, is part of this. This previously used 
the Template Method Design Pattern. See:
http://sourcemaking.com/design_patterns/template_method

Rather than specialized work being done in subclasses, converted this code to what seems to 
be the Decorator Design Pattern. Instead, the GeneratedPrunedOrderedPostOrderNaryTree classes 
accept decoration (?) classes as arguments, the methods of which contain the user's 
specialization code. See:
http://sourcemaking.com/design_patterns/decorator

Or maybe it should be the Visitor Design Pattern:
http://sourcemaking.com/design_patterns/visitor

I would like to make this work for more than one tree at once, and the Node class variables 
are messing this up. Intuition tells me I need a metaclass, singleton class, prototype, or the
like.

Maybe the solution is to use class instance variables.
Did so.
=end
#=========================
module GeneratedPrunedOrderedPostOrderNaryTree
#-----------------------------
  class Node
# TO-DO: Incorporate here the array of sibling choices, or the calls to methods for
# determining same.
    attr_reader :node_decorator
    private_class_method :new

    def initialize( p, n)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Node#initialize'
          @parent = p
# By unwinding the stack, the method, 'initialize' unhelpfully returns not the leaf but the 
# *first* object made, so instead track the leaf by the class variable, processing_node.
      (@node_decorator = n).step_out_branch_leftward( self)
    end

    public
# Maybe change to aliasing 'new'.
    def Node.make_branch_and_return_leaf( *args)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Node.make_branch_and_return_leaf'
      new( *args)
      Node.leaf()
    end

    public
    def Node.capture_leaf( p)
      @processing_node = p
    end

    public
    def Node.counts_to_s
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Node.counts_to_s'
      '@count ' + @count.inspect + "\n"
    end #def

    public
    def Node.each( first_leaf)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Node.each'
#print 'first_leaf '; p first_leaf
      node = first_leaf
# Automatic, depth-first traversal obviates navigating explicitly downward to child nodes.
      (yield node; node = node.create_sibling()) until node.nil?
    end #def

    public
    def Node.get_first_leaf( initial_node_decorator)
      Node.make_branch_and_return_leaf( parent = nil, initial_node_decorator)
    end

    public
    def Node.increment_count
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Node.increment_count'
      @count += 1
    end

    public
    def Node.leaf
      @processing_node
    end

    public
    def Node.set_initial
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Node.set_initial'
      @count = 0
    end

    public
    def create_sibling
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Node#create_sibling'
      return nil if @parent.nil?
      @parent.node_decorator.in_parent_create_next_child( @parent)
    end

  end #class
#-----------------------------
  class Tree
    def initialize( t, initial_node_decorator)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Tree#initialize'
          @tree_decorator = t
      @first_leaf = Node.get_first_leaf( initial_node_decorator)
      @has_been_walked = false
    end

    public
    def walk
      raise 'Only walkable once' if @has_been_walked # I think.
      @has_been_walked = true
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Tree#walk'
      Node.each( @first_leaf) {|node| handle( node)}
      @tree_decorator.walk( counts = Node.counts_to_s())
    end

    private
    def handle( node)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Tree#handle'
      Node.increment_count()
      @tree_decorator.handle( node)
    end #def
  end #class
end #module GeneratedPrunedOrderedPostOrderNaryTree
#=========================
module GeneratedPrunedOrderedPostOrderNaryTreeExample
end #module GeneratedPrunedOrderedPostOrderNaryTreeExample