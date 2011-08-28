discoball
=========

`discoball` is a tool to filter streams and colorize patterns. It functions somewhat like `egrep --color`,
except that it can highlight multiple patterns (in different colors). Patterns are arbitrary ruby regexes that
are matched against the entire line. If the regex contains groups, only the first group's match text is
highlighted.

Usage
-----

    $ discoball [options] <pattern1 pattern2 ...>

where options are:

  * `--group-colors` or `-g`: Color all matches of the same pattern with the same color
  * `--one-color` or `-o`: Highlight all matches with a single color
  * `--match-any` or `-m`: Only print lines matching an input pattern
  * `--match-all` or `-a`: Only print lines matching all input patterns
  * `--help` or `-h`: Print the help message

Examples
--------

  * Highlight instances of "foo" and "bar" in the text of `myfile.txt`:

        $ cat myfile.txt | discoball foo bar

  * Highlight paths of processes running out of `/usr/sbin/`:

        $ ps -ef | discoball --one-color --match-any '/usr/sbin/.*$'

  * I wrote discoball for use with [Steve Losh's todo-list tool, t](https://github.com/sjl/t). I put tags on
    my tasks annotated with `+` (inspired by [Todo.txt](http://todotxt.com/)):

        $ t Make an appointment with the dentist +health

    When I list my tasks (using `t`), I use discoball to highlight the tags with different colors:

        $ t | discoball '\+\S+'

    I can even do some fancier stuff to list particular labels. I have the following function defined in my
    `.bashrc`:

    ``` bash
    function tl() {
      if [ -z  "$1" ]; then
        t | discoball '\+\S+'
      else
        t | discoball -a "${@/#/\+}"
      fi
    }
    ```

    I can use this as follows:

        $ tl               # ~> Show the list of tasks, with tags highlighted
        $ tl health urgent # ~> Show only tasks tagged with 'health' and 'urgent'

    Demo:

    ![Discoball + t demo](http://i.imgur.com/tVQMm.png)

Installation
------------

The easiest way to get `discoball` is by using RubyGems: `$ gem install discoball`. You can also clone the git
repository at `git://github.com/cespare/discoball.git` if you want the latest code.
