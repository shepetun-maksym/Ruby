class HashSet
  def initialize
    @map = HashMap.new
  end

  def add(key)
    @map.set(key, true) 
  end

  def remove(key)
    @map.remove(key)
  end

  def has?(key)
    @map.has?(key)
  end

  def length
    @map.length
  end

  def clear
    @map.clear
  end

  def keys
    @map.keys
  end
end