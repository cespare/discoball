discoball
=========

`discoball` is a tool to filter streams and colorize patterns. It functions somewhat like `egrep --color`,
except that it can highlight multiple patterns (in different colors). Patterns are arbitrary ruby regexes that
are matched against the entire line.

Usage:

    $ discoball [options] <pattern1 pattern2 ...>

Examples:

  * Highlight instances of "foo" and "bar" in the text of `myfile.txt`:

        $ cat myfile.txt | discoball foo bar

  * Highlight paths of processes running out of `/usr/sbin/`:

        $ ps -ef | discoball '/usr/sbin/.*$'
