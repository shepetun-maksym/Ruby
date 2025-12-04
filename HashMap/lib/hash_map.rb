class HashMap
  MAX_LOAD = 0.75

  def initialize
    @table = Array.new(16) { [] }
    @count = 0
  end

  def compute_hash(key)
    h = 0
    key.each_byte do |b|
      h = ((h << 5) - h) + b 
      h &= 0x7fffffff
    end
    h
  end

  def set(key, value)
    grow_if_needed

    idx = compute_hash(key) % @table.length
    bucket = @table[idx]

    bucket.each do |entry|
      if entry[0] == key
        entry[1] = value
        return
      end
    end

    bucket << [key, value]
    @count += 1
  end

  def get(key)
    idx = compute_hash(key) % @table.length
    @table[idx].each do |entry|
      return entry[1] if entry[0] == key
    end
    nil
  end

  def has?(key)
    idx = compute_hash(key) % @table.length
    @table[idx].any? { |entry| entry[0] == key }
  end

  def remove(key)
    idx = compute_hash(key) % @table.length
    bucket = @table[idx]
    bucket.each_with_index do |entry, i|
      if entry[0] == key
        val = entry[1]
        bucket.delete_at(i)
        @count -= 1
        return val
      end
    end
    nil
  end

  def length
    @count
  end

  def clear
    @table = Array.new(16) { [] }
    @count = 0
  end

  def keys
    res = []
    @table.each { |bucket| bucket.each { |entry| res << entry[0] } }
    res
  end

  def values
    res = []
    @table.each { |bucket| bucket.each { |entry| res << entry[1] } }
    res
  end
  def entries
    res = []
    @table.each { |bucket| bucket.each { |entry| res << entry } }
    res
  end

  private

  def grow_if_needed
    if (@count.to_f / @table.length) > MAX_LOAD
      old = @table
      @table = Array.new(@table.length * 2) { [] }
      @count = 0
      old.each do |bucket|
        bucket.each { |entry| set(entry[0], entry[1]) }
      end
    end
  end
end