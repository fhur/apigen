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
  def initialize(line_regex:/\A(#)/, start_regex:/\A(=begin)/, end_regex:/\A(=end)/)
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
    line_commenting = false
    block_commenting = false

    while i < code.size
      chunk = code[i..-1]

      if line_commenting and comment = chunk[/\A((.+)\n)/, 1]
        line_commenting = false
        comment = comment.gsub("\n", "")
        tokens << [:COMMENT, comment]
        i += comment.size
      elsif line_commenting and comment = chunk[/\A(.+$)/, 1]
        line_commenting = false
        tokens << [:COMMENT, comment]
        i += comment.size
      elsif comment_line = chunk[@line_regex, 1]
        line_commenting = true
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
      elsif new_line = chunk[/\A(\n)/, 1]
        tokens << [:NEW_LINE, 'n']
        i += new_line.size

      # if nothing matches, throw an error
      else
        raise "Could not match '#{chunk}'"
      end
    end

    tokens << [:EOF, 'eof']
    return tokens
  end

end
