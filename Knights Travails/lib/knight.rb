#!/usr/bin/env ruby
# frozen_string_literal: true
class Horse
  DEFAULT_SIZE = 8

  STEPS = [
    [2, 1], [1, 2], [-1, 2], [-2, 1],
    [-2, -1], [-1, -2], [1, -2], [2, -1]
  ].freeze

  attr_reader :size

  def initialize(size = DEFAULT_SIZE)
    @size = size
  end

  def shortest_path(from_pos, to_pos)
    return [from_pos] if from_pos == to_pos

    queue = [[from_pos, [from_pos]]]
    seen = { from_pos => true }

    until queue.empty?
      current, path = queue.shift

      STEPS.each do |dx, dy|
        next_pos = [current[0] + dx, current[1] + dy]
        next unless in_bounds?(next_pos)
        next if seen[next_pos]

        new_path = path + [next_pos]
        if next_pos == to_pos
          puts "You made it in #{new_path.length - 1} moves! Here's your path:"
          new_path.each { |p| puts p.inspect }
          return new_path
        end

        seen[next_pos] = true
        queue << [next_pos, new_path]
      end
    end

    nil
  end

  private

  def in_bounds?(pos)
    pos.is_a?(Array) && pos.size == 2 && pos.all? { |c| c.is_a?(Integer) && c.between?(0, size - 1) }
  end
end