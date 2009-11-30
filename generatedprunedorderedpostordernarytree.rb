=begin
Author: Mark D. Blackwell
Date created: April 24, 2009.
Date last changed: May 14, 2009.
Copyright (c) 2009 Mark D. Blackwell.

Name: Generated, pruned, post-order, ordered, n-ary tree.
File: generatedprunedorderedpostordernarytree.rb
Usage: require 'generatedprunedorderedpostordernarytree'

A virtual tree, using depth-first traversal; only a single branch exists at any time. The
module, GeneratedPrunedOrderedPostOrderNaryTreeExample, is part of this. Previously used
the Template Method Design Pattern. See:
http://sourcemaking.com/design_patterns/template_method

Rather than specialized work being done in subclasses, converted this code to what seems to
be the Decorator Design Pattern. Now, the GeneratedPrunedOrderedPostOrderNaryTree classes
accept decoration (?) classes as arguments, the methods of which contain the user's
specialization code. See:
http://sourcemaking.com/design_patterns/decorator

Or maybe it should be the Visitor Design Pattern:
http://sourcemaking.com/design_patterns/visitor

I would like to make this work for more than one tree at once. The Leaf class variables
were messing that up. Changed to use class instance variables. Maybe it is good, now?
=end
#=========================
module GeneratedPrunedOrderedPostOrderNaryTree
#-----------------------------
  class Leaf
    class << Leaf
      alias old_new new
      attr_reader :leaf_decorator_class
      attr_accessor :processing_leaf
    end
    attr_reader :leaf_decorator,
                :parent
    public
    def Leaf.new( *args)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Leaf.new'
      Leaf.old_new( *args)
# By unwinding the stack, methods, 'Leaf.old_new' and 'initialize' unhelpfully return not the
# leaf but the *first* node made, so we instead remember the leaf in the class instance
# variable, 'processing_leaf'.
      Leaf.processing_leaf
    end

    public
    def initialize( p, n)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Leaf#initialize'
          @parent = p
          @leaf_decorator = n
      step_out_branch_leftward()
    end

    private
    def step_out_branch_leftward
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Leaf#step_out_branch_leftward'
      until @leaf_decorator.candidate().nil?
        try = @leaf_decorator.data_for_child()
        @leaf_decorator.next_candidate()
        next if @leaf_decorator.forbear?( try)
        Leaf.new( parent = self, Leaf.leaf_decorator_class.new( try))
        break
      end #until
# Assume that before this leaf (self) was created, it was checked regarding forbearance.
      Leaf.processing_leaf = self if @leaf_decorator.candidate().nil?
      Leaf.processing_leaf
    end

    public # Invoked from another node.
    def next_candidate
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Leaf#next_candidate'
      return Leaf.processing_leaf = self if @leaf_decorator.candidate().nil? # No more siblings.
      try = @leaf_decorator.data_for_child()
      @leaf_decorator.next_candidate()
      return next_candidate() if @leaf_decorator.forbear?( try)
      Leaf.new( parent = self, Leaf.leaf_decorator_class.new( try))
    end #def

    public
    def Leaf.each( first_leaf)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Leaf.each'
# Automatic, depth-first traversal obviates navigating explicitly downward to child leaves.
#print 'first_leaf '; p first_leaf
      leaf = first_leaf
      until leaf.nil?
        yield leaf
        leaf = leaf.parent.nil? ? nil : leaf.parent.next_candidate()
      end #until
    end #def

    private
    def Leaf.get_first_leaf( initial_leaf_decorator)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Leaf.get_first_leaf'
      Leaf.new( parent = nil, initial_leaf_decorator)
    end

    public
    def Leaf.set_initial( d)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Leaf.set_initial'
      @leaf_decorator_class = d
    end
  end #class
#-----------------------------
  class Tree
    def initialize( t, initial_leaf_decorator)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Tree#initialize'
          @tree_decorator = t
      @first_leaf = Leaf.get_first_leaf( initial_leaf_decorator)
      @has_been_walked = false
    end

    public
    def walk
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Tree#walk'
      raise 'Only walkable once' if @has_been_walked # I think.
      @has_been_walked = true
      @count = 0
      Leaf.each( @first_leaf) {|leaf| handle( leaf)}
      @tree_decorator.walk( @count.to_s)
    end

    private
    def handle( leaf)
#p 'in GeneratedPrunedOrderedPostOrderNaryTree::Tree#handle'
      @count += 1
      @tree_decorator.handle( leaf)
    end #def
  end #class
end #module GeneratedPrunedOrderedPostOrderNaryTree
#=========================
module GeneratedPrunedOrderedPostOrderNaryTreeExample
#-----------------------------
  class LeafDecorator

    def initialize( a)
#p 'in GeneratedPrunedOrderedPostOrderNaryTreeExample::LeafDecorator#initialize'
          @absolutes = a
      @candidate_intervals_index = 0
    end #def

    public
    def LeafDecorator.set_fixed( n)
#p 'in GeneratedPrunedOrderedPostOrderNaryTreeExample::LeafDecorator.set_fixed'
      @@candidates = (1..4).to_a
      '@@candidates ' + @@candidates.inspect + "\n"
    end #def

    public
    def LeafDecorator.initial
#p 'in GeneratedPrunedOrderedPostOrderNaryTreeExample::LeafDecorator.initial'
      LeafDecorator.new( [0])
    end

    public
    def forbear?( a) # Anything bad?
#p 'in GeneratedPrunedOrderedPostOrderNaryTreeExample::LeafDecorator#forbear?'
    end

    public
    def data_for_child
#p 'in GeneratedPrunedOrderedPostOrderNaryTreeExample::LeafDecorator#data_for_child'
    end

    public
    def candidate
#p 'in GeneratedPrunedOrderedPostOrderNaryTreeExample::LeafDecorator#candidate'
    end

    public
    def next_candidate
#p 'in GeneratedPrunedOrderedPostOrderNaryTreeExample::LeafDecorator#next_candidate'
    end

  end #class LeafDecorator
#-----------------------------
  class TreeDecorator
    def initialize( n)
      @note_space = n
#p 'in GeneratedPrunedOrderedPostOrderNaryTreeExample::TreeDecorator#initialize'
      @fixed = LeafDecorator.set_fixed( @note_space)
      GeneratedPrunedOrderedPostOrderNaryTree::Leaf.set_initial( LeafDecorator)
    end

    def walk( counts)
#p 'in GeneratedPrunedOrderedPostOrderNaryTreeExample::TreeDecorator#walk'
    end

    def handle( leaf)
#p 'in GeneratedPrunedOrderedPostOrderNaryTreeExample::TreeDecorator#handle'
    end #def

  end #class TreeDecorator
end #module GeneratedPrunedOrderedPostOrderNaryTreeExample
