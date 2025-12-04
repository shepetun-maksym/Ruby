# frozen_string_literal: true

# Помилка для заборонених ходів — будь-який хід, що не відповідає правилам шахів
class IllegalMoveError < StandardError
  def initialize(msg = 'Неприпустимий хід')
    super
  end
end
