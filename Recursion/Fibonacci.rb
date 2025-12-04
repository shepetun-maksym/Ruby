def gen_fib(n)
  return [] if n <= 0
  return [0] if n == 1

  result = [0, 1]
  (2...n).each do
    a, b = result[-2], result[-1]
    result << a + b
  end
  result
end

def gen_fib_recursive(n)
  return [] if n <= 0
  return [0] if n == 1
  return [0, 1] if n == 2

  shorter = gen_fib_recursive(n - 1)
  shorter + [shorter[-1] + shorter[-2]]
end

if __FILE__ == $0
  p gen_fib(8)
  p gen_fib_recursive(8)
end