import unittest, re
from discoball import Discoball
from fabulous.color import red, green, yellow, blue, magenta, cyan, underline

class TestDiscoball(unittest.TestCase):
  def setUp(self):
    self.dball = Discoball([re.compile('\+\w+')], "one", "all")
  def testNoMatch(self):
    line = 'no match'
    self.assertEqual(line, self.dball.colorize(line))
  def testSimpleMatch(self):
    line = '+tag'
    expected = str(underline(blue(line)))
    self.assertEqual(expected, self.dball.colorize(line))

if __name__ == "__main__":
  unittest.main()
