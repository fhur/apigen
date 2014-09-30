#
# Runs through a block of code an extracts all comment blocks
# Supports 4 types of tokens
# COMMENT_LINE: Indicates the start of a comment line. In Java this should be // or *, in ruby #
# COMMENT_START: Indicates the start of a comment. In languages like Java this should be /** or /*
# COMMENT_END: Indicates the termination of a comment.
# IDENTIFIER: Any non whitespace 'word' that is not a COMMENT_LINE, COMMENT_START or COMMENT_END
# NEW_LINE: matches \n
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

    # If true, it means that all subsequent tokens are part of the comment
    # The rules for is_commenting are as follows:
    # 1. If start_regex is found, everything is a comment until
    # end_regex is found
    # 2. If line_regex is found, everything is a comment until "\n" is found
    is_line_commenting = false
    is_block_commenting = false

    while i < code.size
      chunk = code[i..-1]

      if is_line_commenting
        is_line_commenting = false
        if comment = chunk[/\A((.+)\n)/, 1]
          tokens << [:COMMENT, comment]
          i += comment.size
        else
          tokens << [:COMMENT, chunk]
          i += chunk.size
        end
      end

      if comment_start = chunk[@start_regex, 1]
        tokens << [:COMMENT_START, comment_start]
        is_block_commenting = true
        i += comment_start.size

      elsif comment_end = chunk[@end_regex, 1]
        tokens << [:COMMENT_END, comment_end]
        is_block_commenting = false
        i += comment_end.size

      elsif comment_line = chunk[@line_regex, 1]
        is_line_commenting = true
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
        tokens << [:NEW_LINE, 'n']
        i += 1

      # if nothing matches, throw an error
      else
        raise "Could not match '#{chunk}'"
      end
    end
    return tokens
  end

end
