class Participant
  attr_accessor :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def to_s
    @symbol
  end
end