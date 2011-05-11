#!/usr/bin/env ruby

require "colorize"

module Discoball
  UNUSABLE_COLORS = [/black$/, /^default$/, /white$/, /^light/]

  class Highlighter
    def initialize(patterns)
      @patterns = patterns
      @color_stack = String.colors.reject { |color| UNUSABLE_COLORS.any? { |unusable| color =~ unusable } }
      @color_assignments = {}
    end

    def filter(line)
      matches = @patterns.flat_map { |pattern| line.scan(pattern) }.uniq
      matches.each { |match| line.gsub!(match, highlight(match)) }
      line
    end

    private

    def highlight(match)
      unless @color_assignments.include? match
        color = @color_stack.pop
        @color_stack.insert(0, color)
        @color_assignments[match] = color
      end
      match.colorize(@color_assignments[match]).underline
    end
  end
end
