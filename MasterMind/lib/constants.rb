module Constants
  COLORS = {
    red: "\e[31m",
    blue: "\e[34m",
    green: "\e[32m",
    yellow: "\e[33m",
    cyan: "\e[36m",
    purple: "\e[35m"
  }.freeze
  POSSIBLE_COLORS = %w[red blue green yellow cyan purple].freeze
  PATTERN = "\\b(?:#{POSSIBLE_COLORS.join('|')})\\b"
end