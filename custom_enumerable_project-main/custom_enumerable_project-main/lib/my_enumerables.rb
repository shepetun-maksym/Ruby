module Enumerable
  def log_info
    puts("#{self}")
  end

  def my_all?
    return true unless any? { |e| !(block_given? ? yield(e) : e) }
    false
  end

  def my_any?
    each do |e|
      return true if block_given? ? yield(e) : e
    end
    false
  end

  def my_count
    total = 0
    each { |e| total += 1 if block_given? ? yield(e) : !!e }
    total
  end

  def my_each
    i = 0
    ary = to_a
    while i < ary.size
      yield ary[i]
      i += 1
    end
    self
  end

  def my_each_with_index
    idx = 0
    my_each do |e|
      yield(e, idx)
      idx += 1
    end
    self
  end

  def my_inject(initial = 0)
    result = initial
    my_each { |e| result = yield(result, e) }
    result
  end

  def my_map
    out = []
    my_each { |e| out << yield(e) }
    out
  end

  def my_none?
    my_each { |e| return false if yield(e) }
    true
  end

  def my_select
    result = []
    my_each { |e| result << e if yield(e) }
    result
  end
end

test_array = (1..20).to_a
test_array.log_info