# frozen_string_literal: true

# Помилка для некоректних координат поля (не в діапазоні a-h або 1-8)
class InvalidCoordinateError < StandardError
  def initialize(msg = 'Неприпустима координата на дошці')
    super
  end
end
