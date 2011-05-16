#!/usr/bin/env python
import argparse, sys, re
from fabulous.color import red, green, yellow, blue, magenta, cyan, underline

class Discoball(object):
  colors = [red, green, yellow, blue, magenta, cyan]

  def __init__(self, patterns, color_mode, match_mode):
    self.patterns = patterns
    self.color_mode = color_mode
    self.match_mode = match_mode
    self.color_assignments = {}

  def get_next_color(self):
    color = self.colors.pop(0)
    self.colors.append(color)
    return color

  def _colorize_helper(self, patterns_matched, line, color_fn):
    colorized_line= line
    matches_replaced = {}
    for pattern in self.patterns:
      matches = self.get_matches(line, pattern, patterns_matched)
      for match in matches:
        if match in matches_replaced:
          next
        matches_replaced[match] = True
        colorized_line = color_fn(colorized_line, pattern, match)
    return colorized_line

  def _one_colorize(self, line, pattern, match):
    return line.replace(match, str(underline(blue(match))))

  def _group_colorize(self, line, pattern, match):
    if pattern not in self.color_assignments:
      self.color_assignments[pattern] = self.get_next_color()
    return line.replace(match, str(underline(self.color_assignments[pattern](match))))

  def _individual_colorize(self, line, pattern, match):
    if match not in self.color_assignments:
      self.color_assignments[match] = self.get_next_color()
    return line.replace(match, str(underline(self.color_assignments[match](match))))


  def colorize(self, line):
    patterns_matched = {}
    if self.color_mode == "one":
      colorized_line = self._colorize_helper(patterns_matched, line, self._one_colorize)
    elif self.color_mode == "group":
      colorized_line = self._colorize_helper(patterns_matched, line, self._group_colorize)
    elif self.color_mode == "individual":
      colorized_line = self._colorize_helper(patterns_matched, line, self._individual_colorize)

    if self.match_mode == "match_any" and len(patterns_matched) > 0:
      return colorized_line
    elif self.match_mode == "match_all" and len(patterns_matched) == len(self.patterns):
      return colorized_line
    elif self.match_mode == "all":
      return colorized_line
    else:
      return None

  def get_matches(self, line, pattern, patterns_matched):
    matches = re.findall(pattern, line)
    if len(matches) > 0:
      patterns_matched[pattern] = True
    return matches

def main():
  parser = argparse.ArgumentParser(description='Highlight matches in a stream.')
  parser.add_argument('patterns', metavar='pattern', type=str, nargs='+', help='Regexs to match with')
  parser.add_argument('--one-color', dest='one_color', action='store_true', default=False,
                      help='Color all with the same color')
  parser.add_argument('--group-colors', dest='group_colors', action='store_true', default=False,
                      help='Color all matches of the same pattern with the same color')
  parser.add_argument('--match-any', dest='match_any', action='store_true', default=False,
                      help='Only print lines matching an input pattern')
  parser.add_argument('--match-all', dest='match_all', action='store_true', default=False,
                      help='Only print lines matching all input patterns')
  args = parser.parse_args()
  if args.one_color and args.group_colors:
    print "Only one of [--group-colors, --one-color] can be set"
    sys.exit()
  elif args.one_color:
    color_mode = "one"
  elif args.group_colors:
    color_mode = "group"
  else:
    color_mode = "individual"

  if args.match_any and args.match_all:
    print "Only one of [--match-any, --match-all] can be set"
    sys.exit()
  elif args.match_any:
    match_mode = "match_any"
  elif args.match_all:
    match_mode = "match_all"
  else:
    match_mode = "all"

  patterns = []
  for pattern in args.patterns:
    try:
      patterns.append(re.compile(pattern))
    except:
      print 'Cannot compile regex: "%s"' % pattern
      sys.exit()

  discoball = Discoball(patterns, color_mode, match_mode)

  for line in sys.stdin:
    highlighted = discoball.colorize(line)
    if highlighted is not None:
      print highlighted,

if __name__ == "__main__":
  main()
