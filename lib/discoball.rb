#!/usr/bin/env ruby

require "rubygems"
require "colorize"

module Discoball
  UNUSABLE_COLORS = [/black$/, /^default$/, /white$/, /^light/]
  SINGLE_COLOR = :blue

  class Highlighter
    # Patterns is an array of patterns to match. There are two options that can be changed:
    #   * color_mode
    #     -:individual - each unique string matching one of the patterns will be a different color.
    #     -:group_colors - the matches corresponding to each pattern will be the same color.
    #     -:one_color - all matches will be a single color.
    #   * match_mode
    #     -:all - all lines are returned
    #     -:match_any - lines matching any pattern are returned
    #     -:match_all - only lines matching every pattern are returned
    def initialize(patterns, color_mode = :individual, match_mode = :all)
      @patterns = patterns
      @color_mode = color_mode
      @match_mode = match_mode
      @color_stack = String.colors.reject { |color| UNUSABLE_COLORS.any? { |unusable| color =~ unusable } }
      @color_assignments = {}
      if color_mode == :group_colors
        @patterns.each { |pattern| @color_assignments[pattern] = pop_rotate }
      end
    end

    def filter(line)
      match_found = {}
      @patterns.each { |pattern| match_found[pattern] = false }

      case @color_mode
      when :one_color
        matches = @patterns.reduce([]) { |memo, pattern| # No Array#flat_map in Ruby 1.8 :\
          m = line.scan(pattern).map do |mstr|
            if mstr.class == Array # Has group(s)
              mstr[0]
            else
              mstr
            end
          end
          match_found[pattern] = true unless m.empty?
          memo += m
        }.uniq
        matches.each { |match| highlight!(line, match, SINGLE_COLOR) }
      when :group_colors
        @patterns.each do |pattern|
          matches = line.scan(pattern).map do |mstr|
            if mstr.class == Array
              mstr[0]
            else
              mstr
            end
          end.uniq
          match_found[pattern] = true unless matches.empty?
          matches.each { |match| highlight!(line, match, @color_assignments[pattern]) }
        end
      when :individual
        matches = @patterns.reduce([]) { |memo, pattern|
          m = line.scan(pattern).map do |mstr|
            if mstr.class == Array
              mstr[0]
            else
              mstr
            end
          end
          match_found[pattern] = true unless m.empty?
          memo += m
        }.uniq
        matches.each do |match|
          unless @color_assignments.include? match
            @color_assignments[match] = pop_rotate
          end
          matches.each { |match| highlight!(line, match, @color_assignments[match]) }
        end
      end

      case @match_mode
      when :match_any
        match_found.any? { |pattern, found| found } ? line : nil
      when :match_all
        match_found.all? { |pattern, found| found } ? line : nil
      else
        line
      end
    end

    private

    def highlight!(line, match, color)
      line.gsub!(match, match.colorize(color).underline)
    end

    # Get the next color and put it at the back
    def pop_rotate
      color = @color_stack.pop
      @color_stack.unshift color
      color
    end
  end
end
