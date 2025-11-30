def caesar_cipher(string, shift)
  result = ""

  string.each_char do |char|
    if char.match?(/[A-Za-z]/)
      base = char >= "a" ? "a".ord : "A".ord

      new_char = ((char.ord - base + shift) % 26) + base

      result << new_char.chr
    else
      result << char
    end
  end

  result
end

puts caesar_cipher("What a string!", 5)