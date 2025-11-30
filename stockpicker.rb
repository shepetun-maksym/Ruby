def stock_picker(prices)
  min_price_index = 0
  max_profit = 0
  best_days = [0, 0]

  prices.each_with_index do |current_price, current_index|
    # Якщо знайшли нову найнижчу ціну — запам'ятовуємо її індекс
    if current_price < prices[min_price_index]
      min_price_index = current_index
      next
    end

    # Рахуємо прибуток, якщо продати сьогодні (поточна ціна - мінімальна знайдена раніше)
    current_profit = current_price - prices[min_price_index]

    # Якщо цей прибуток більший за рекордний — оновлюємо дані
    if current_profit > max_profit
      max_profit = current_profit
      best_days = [min_price_index, current_index]
    end
  end

  best_days
end

print stock_picker([17,3,6,9,15,8,6,1,10])
# Результат: [1, 4] (Купили за 3, продали за 15)