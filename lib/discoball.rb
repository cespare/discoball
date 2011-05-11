#!/usr/bin/env ruby

require "colorize"

module Discoball
  UNUSABLE_COLORS = [/black$/, /^default$/, /white$/, /^light/]
  SINGLE_COLOR = :blue

  class Highlighter
    # Patterns is an array of patterns to match. There are three options that can be changed:
    #   * If color_mode is :individual, then each unique string matching one of the patterns will be a
    #       different color.
    #   * If color_mode is :group_colors, then the matches corresponding to each pattern will be the same color.
    #   * If color_mode is :one_color, then all matches will be a single color.
    #   * If match_only is set, then only matching lines will be returned.
    def initialize(patterns, color_mode = :individual, match_only = false)
      @patterns = patterns
      @color_mode = color_mode
      @match_only = match_only
      @color_stack = String.colors.reject { |color| UNUSABLE_COLORS.any? { |unusable| color =~ unusable } }
      @color_assignments = {}
      if color_mode == :group_colors
        @patterns.each { |pattern| @color_assignments[pattern] = pop_rotate }
      end
    end

    def filter(line)
      match_found = false
      case @color_mode
      when :one_color
        matches = @patterns.flat_map { |pattern| line.scan(pattern) }.uniq
        match_found ||= !matches.empty?
        matches.each { |match| highlight!(line, match, SINGLE_COLOR) }
      when :group_colors
        @patterns.each do |pattern|
          matches = line.scan(pattern).uniq
          match_found ||= !matches.empty?
          matches.each { |match| highlight!(line, match, @color_assignments[pattern]) }
        end
      when :individual
        matches = @patterns.flat_map { |pattern| line.scan(pattern) }.uniq
        match_found ||= !matches.empty?
        matches.each do |match|
          unless @color_assignments.include? match
            @color_assignments[match] = pop_rotate
          end
          matches.each { |match| highlight!(line, match, @color_assignments[match]) }
        end
      end
      (@match_only && !match_found) ? nil : line
    end

    private

    def highlight!(line, match, color)
      line.gsub!(match, match.colorize(color).underline)
    end

    # Get the next color and put it at the back
    def pop_rotate
      color = @color_stack.pop
      @color_stack.insert(0, color)
      color
    end
  end
end
