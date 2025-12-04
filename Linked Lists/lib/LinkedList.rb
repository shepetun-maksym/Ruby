class Element
  attr_accessor :data, :next_element

  def initialize(data = nil, next_element = nil)
    @data = data
    @next_element = next_element
  end
end


class SinglyLinked
  def initialize
    @start = nil
  end

  def push_back(val)
    node = Element.new(val)
    if @start.nil?
      @start = node
      return
    end
    last.next_element = node
  end

  def push_front(val)
    @start = Element.new(val, @start)
  end

  def length
    cnt = 0
    cur = @start
    while cur
      cnt += 1
      cur = cur.next_element
    end
    cnt
  end

  def first
    @start
  end

  def last
    return nil if @start.nil?
    cur = @start
    cur = cur.next_element while cur.next_element
    cur
  end

  def node_at(idx)
    cur = @start
    i = 0
    while cur && i < idx
      cur = cur.next_element
      i += 1
    end
    cur
  end

  def remove_last
    return nil if @start.nil?
    if @start.next_element.nil?
      @start = nil
      return
    end
    cur = @start
    cur = cur.next_element while cur.next_element && cur.next_element.next_element
    cur.next_element = nil
  end

  def includes?(val)
    cur = @start
    while cur
      return true if cur.data == val
      cur = cur.next_element
    end
    false
  end

  def index_of(val)
    i = 0
    cur = @start
    while cur
      return i if cur.data == val
      i += 1
      cur = cur.next_element
    end
    nil
  end

  def to_s
    cur = @start
    s = ''
    while cur
      s << "( #{cur.data} ) -> "
      cur = cur.next_element
    end
    s + 'nil'
  end

  def insert_at(val, idx)
    return push_front(val) if idx == 0
    prev = node_at(idx - 1)
    return nil if prev.nil?
    new_el = Element.new(val, prev.next_element)
    prev.next_element = new_el
  end

  def remove_at(idx)
    return @start = @start.next_element if idx == 0 && @start
    prev = node_at(idx - 1)
    return nil if prev.nil? || prev.next_element.nil?
    prev.next_element = prev.next_element.next_element
  end

  private

  def last
    cur = @start
    return nil if cur.nil?
    cur = cur.next_element while cur.next_element
    cur
  end
end