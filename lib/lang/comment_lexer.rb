#
# Runs through a block of code an extracts all comment blocks
# Supports 4 types of tokens
# COMMENT_LINE: Indicates the start of a comment line. In Java this should be // or *, in ruby #
# COMMENT_START: Indicates the start of a comment. In languages like Java this should be /** or /*
# COMMENT_END: Indicates the termination of a comment.
# IDENTIFIER: Any non whitespace 'word' that is not a COMMENT_LINE, COMMENT_START or COMMENT_END
#
# Whitespace and line ends are ignored
class CommentLexer

  attr_reader :line_regex
  attr_reader :start_regex
  attr_reader :end_regex

  # Initializes the CommentLexer
  # @param {regex} line_regex a regex that matches the comment lines.
  # @param {regex} start_regex a regex that matches the start of a comment block.
  # @param {regex} end_regex a regex that matches the termination of a comment block.
  def initialize(line_regex:nil, start_regex:nil, end_regex:nil)
    @line_regex = line_regex
    @start_regex = start_regex
    @end_regex = end_regex
  end

  def tokenize(code)
    code.chomp!
    tokens = [] # every token is a [:name, :value] pair
    i = 0 # hold the current index
    while i < code.size
      chunk = code[i..-1]

      # First we will match all keywords
      # i.e. @query, @param, @header, @path
      if comment_start = chunk[@start_regex, 1]
        tokens << [:COMMENT_START, comment_start]
        i += comment_start.size

      # Now we match http methods
      # get, post, put, delete, etc.
      elsif comment_end = chunk[@end_regex, 1]
        tokens << [:COMMENT_END, comment_end]
        i += comment_end.size

      # Now we match urls
      # Urls are all strings starting
      # with / up to the last non whitespace character
      elsif comment_line = chunk[@line_regex, 1]
        tokens << [:COMMENT_LINE, comment_line]
        i += comment_line.size

      # finally match all 'words' as identifiers. A word
      # is any non whitespace character.
      elsif identifier = chunk[/\A(\S+)/, 1]
        tokens << [:IDENTIFIER, identifier]
        i += identifier.size

      # skip spaces
      elsif chunk.match(/\A /)
        i += 1

      # skip \n
      elsif chunk.match(/\A\n/)
        i += 1

      # if nothing matches, throw an error
      else
        raise "Could not match '#{chunk}'"
      end
    end
    return tokens
  end

end
