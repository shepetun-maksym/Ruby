def divide_and_sort(list)
  return list if list.size <= 1

  mid = (list.size / 2.0).floor
  left = divide_and_sort(list[0...mid])
  right = divide_and_sort(list[mid..-1])

  join_sorted(left, right)
end

def join_sorted(a, b)
  out = []
  la = a.dup
  lb = b.dup

  until la.empty? || lb.empty?
    if la.first <= lb.first
      out << la.shift
    else
      out << lb.shift
    end
  end

  out + la + lb
end

# Simple tests
if __FILE__ == $0
  p divide_and_sort([])
  p divide_and_sort([73])
  p divide_and_sort([1, 2, 3, 4, 5])
  p divide_and_sort([3, 2, 1, 13, 8, 5, 0, 1])
  p divide_and_sort([105, 79, 100, 110])
end
def divide_and_sort(list)
  return list if list.size <= 1

  mid = (list.size / 2.0).floor
  left = divide_and_sort(list[0...mid])
  right = divide_and_sort(list[mid..-1])

  join_sorted(left, right)
end

def join_sorted(a, b)
  out = []
  la = a.dup
  lb = b.dup

  until la.empty? || lb.empty?
  if la.first <= lb.first
  out << la.shift
  else
  out << lb.shift
  end
  end

  out + la + lb
end

if __FILE__ == $0
  p divide_and_sort([])
  p divide_and_sort([73])
  p divide_and_sort([1, 2, 3, 4, 5])
  p divide_and_sort([3, 2, 1, 13, 8, 5, 0, 1])
  p divide_and_sort([105, 79, 100, 110])
end
def merge_sort(arr)
  return arr if arr.length <= 1

  mid = arr.length / 2
  left = merge_sort(arr[0...mid])
  right = merge_sort(arr[mid..])

  merge(left, right)
end


def merge(left, right)
  result = []
  i = 0
  j = 0

  while i < left.length && j < right.length
    if left[i] <= right[j]
      result << left[i]
      i += 1
    else
      result << right[j]
      j += 1
    end
  end

  result + left[i..] + right[j..]
end

p merge_sort([])
p merge_sort([73])
p merge_sort([1, 2, 3, 4, 5])
#!/usr/bin/env ruby
# frozen_string_literal: true

# Implements merge-sort but with different naming and small style changes
def divide_and_sort(list)
  return list if list.size <= 1

  mid = (list.size / 2.0).floor
  left = divide_and_sort(list[0...mid])
  right = divide_and_sort(list[mid..-1])

  join_sorted(left, right)
end

def join_sorted(a, b)
  out = []
  la = a.dup
  lb = b.dup

  until la.empty? || lb.empty?
    if la.first <= lb.first
      out << la.shift
    else
      out << lb.shift
    end
  end

  out + la + lb
end

if __FILE__ == $0
  p divide_and_sort([])
  p divide_and_sort([73])
  p divide_and_sort([1, 2, 3, 4, 5])
  p divide_and_sort([3, 2, 1, 13, 8, 5, 0, 1])
  p divide_and_sort([105, 79, 100, 110])
end