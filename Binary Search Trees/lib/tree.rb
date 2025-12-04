#!/usr/bin/env ruby
# frozen_string_literal: true

# Binary search tree implementation (refactored names and style)
class BinarySearchTree
  attr_accessor :root

  def initialize(values)
    @root = build_tree(values)
  end

  def build_tree(values)
    return nil if values.nil? || values.empty?

    arr = values.uniq.sort
    mid = arr.length / 2
    node = BSTNode.new(arr[mid])

    node.left = build_tree(arr[0...mid])
    node.right = build_tree(arr[mid + 1..-1])

    node
  end

  def insert(val, current = @root)
    return @root = BSTNode.new(val) if @root.nil?

    if val < current.value
      current.left.nil? ? current.left = BSTNode.new(val) : insert(val, current.left)
    else
      current.right.nil? ? current.right = BSTNode.new(val) : insert(val, current.right)
    end
  end

  def delete(val, current = @root)
    return nil if current.nil?

    if val == current.value
      if current.left.nil? && current.right.nil?
        return nil
      elsif current.right.nil?
        return current.left
      elsif current.left.nil?
        return current.right
      else
        succ = current.right
        succ = succ.left while succ.left
        current.value = succ.value
        current.right = delete(succ.value, current.right)
      end
    elsif val < current.value
      current.left = delete(val, current.left)
    else
      current.right = delete(val, current.right)
    end

    current
  end

  def find(val, current = @root)
    return nil if current.nil?
    return current if val == current.value
    val < current.value ? find(val, current.left) : find(val, current.right)
  end

  def level_order
    q = [@root]
    out = []
    while !q.empty?
      cur = q.shift
      if block_given?
        yield cur
      else
        out << cur.value
      end
      q << cur.left if cur.left
      q << cur.right if cur.right
    end
    return out unless block_given?
  end

  def inorder
    stack = []
    cur = @root
    out = []
    while cur || !stack.empty?
      while cur
        stack << cur
        cur = cur.left
      end
      cur = stack.pop
      block_given? ? yield(cur) : out << cur.value
      cur = cur.right
    end
    out
  end

  def preorder(out = [], current = @root)
    return out if current.nil?
    block_given? ? yield(current) : out << current.value
    if block_given?
      preorder(out, current.left) { |n| yield n }
      preorder(out, current.right) { |n| yield n }
    else
      preorder(out, current.left)
      preorder(out, current.right)
    end
    out
  end

  def postorder(out = [], current = @root)
    return out if current.nil?
    if block_given?
      postorder(out, current.left) { |n| yield n }
      postorder(out, current.right) { |n| yield n }
      yield current
    else
      postorder(out, current.left)
      postorder(out, current.right)
      out << current.value
    end
    out
  end

  def height(node)
    return -1 if node.nil?
    lh = height(node.left)
    rh = height(node.right)
    [lh, rh].max + 1
  end

  def depth(node, current = @root, d = 0)
    return nil if current.nil?
    return d if node.value == current.value
    node.value < current.value ? depth(node, current.left, d + 1) : depth(node, current.right, d + 1)
  end

  def balanced?
    return true if @root.nil?
    lh = height(@root.left)
    rh = height(@root.right)
    return false if (lh - rh).abs > 1 || lh == -1 || rh == -1
    true
  end

  def rebalance
    arr = inorder
    @root = build_tree(arr)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end


  def build_tree(array)
    return nil if array.empty?

    array = array.uniq.sort
    middle_index = array.length / 2
    node = Node.new(array[middle_index])

    node.left = build_tree(array[0...middle_index])
    class BinarySearchTree
      attr_accessor :root

      def initialize(values)
        @root = build_tree(values)
      end

      def build_tree(values)
        return nil if values.nil? || values.empty?

        arr = values.uniq.sort
        mid = arr.length / 2
        node = BSTNode.new(arr[mid])

        node.left = build_tree(arr[0...mid])
        node.right = build_tree(arr[mid + 1..-1])

        node
      end

      def insert(val, current = @root)
        return @root = BSTNode.new(val) if @root.nil?

        if val < current.value
          current.left.nil? ? current.left = BSTNode.new(val) : insert(val, current.left)
        else
          current.right.nil? ? current.right = BSTNode.new(val) : insert(val, current.right)
        end
      end

      def delete(val, current = @root)
        return nil if current.nil?

        if val == current.value
          if current.left.nil? && current.right.nil?
            return nil
          elsif current.right.nil?
            return current.left
          elsif current.left.nil?
            return current.right
          else
            succ = current.right
            succ = succ.left while succ.left
            current.value = succ.value
            current.right = delete(succ.value, current.right)
          end
        elsif val < current.value
          current.left = delete(val, current.left)
        else
          current.right = delete(val, current.right)
        end

        current
      end

      def find(val, current = @root)
        return nil if current.nil?
        return current if val == current.value
        val < current.value ? find(val, current.left) : find(val, current.right)
      end

      def level_order
        q = [@root]
        out = []
        while !q.empty?
          cur = q.shift
          if block_given?
            yield cur
          else
            out << cur.value
          end
          q << cur.left if cur.left
          q << cur.right if cur.right
        end
        return out unless block_given?
      end

      def inorder
        stack = []
        cur = @root
        out = []
        while cur || !stack.empty?
          while cur
            stack << cur
            cur = cur.left
          end
          cur = stack.pop
          block_given? ? yield(cur) : out << cur.value
          cur = cur.right
        end
        out
      end

      def preorder(out = [], current = @root)
        return out if current.nil?
        block_given? ? yield(current) : out << current.value
        if block_given?
          preorder(out, current.left) { |n| yield n }
          preorder(out, current.right) { |n| yield n }
        else
          preorder(out, current.left)
          preorder(out, current.right)
        end
        out
      end

      def postorder(out = [], current = @root)
        return out if current.nil?
        if block_given?
          postorder(out, current.left) { |n| yield n }
          postorder(out, current.right) { |n| yield n }
          yield current
        else
          postorder(out, current.left)
          postorder(out, current.right)
          out << current.value
        end
        out
      end

      def height(node)
        return -1 if node.nil?
        lh = height(node.left)
        rh = height(node.right)
        [lh, rh].max + 1
      end

      def depth(node, current = @root, d = 0)
        return nil if current.nil?
        return d if node.value == current.value
        node.value < current.value ? depth(node, current.left, d + 1) : depth(node, current.right, d + 1)
      end

      def balanced?
        return true if @root.nil?
        lh = height(@root.left)
        rh = height(@root.right)
        return false if (lh - rh).abs > 1 || lh == -1 || rh == -1
        true
      end

      def rebalance
        arr = inorder
        @root = build_tree(arr)
      end

      def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
      end
    end
  end