require_relative './comment_lexer'

class CommentParser

  def initialize
    @lexer = CommentLexer.new
  end


  def parse(code, print_tokens=false)
    tokens = @lexer.tokenize code
    p tokens if print_tokens
    # iterate through all the tokens
    # if a COMMENT_START is found, the next token should be a COMMENT followed by a COMMENT_END
    # if a COMMENT_LINE is found, the next token can be a NEW_LINE, EOF or COMMENT.
    result = []
    line_commenting = false
    comment_block = []
    consecutive_new_lines = 0
    tokens.each do |token|
      id = token.first
      value = token.last
      if line_commenting and id == :COMMENT
        comment_block << value
        consecutive_new_lines = 0
      elsif line_commenting and id == :NEW_LINE
        consecutive_new_lines += 1
        if consecutive_new_lines > 1
          result << comment_block
          line_commenting = false
        end
      elsif line_commenting and id == :EOF
        # ignore EOF
        result << comment_block
        consecutive_new_lines = 0
      elsif line_commenting and id == :IDENTIFIER
        line_commenting = false
        result << comment_block
        consecutive_new_lines = 0
      elsif line_commenting and id == :COMMENT_LINE
        # ignore comment line
        consecutive_new_lines = 0
      elsif id == :COMMENT_LINE
        comment_block = []
        line_commenting = true
        consecutive_new_lines = 0
      end
    end
    return result
  end

  # Given a string of code as input, this method removes all non comments
  # and returns the resulting string. Comments are then split into blocks
  # and returned as an array.
  #
  # Example: Given the following text as input
  # # comment 1
  # # comment 2
  # # comment 3
  # def some method here
  #   some_code_here
  #   some_more_code
  #   # another comment
  # end
  #
  # # another comment
  # def more_code
  # end
  #
  # This will be returned
  # [ " comment 1\n comment2\n comment3 ", " another comment", " another comment" ]
  def parse_and_join(code, print_tokens = false)
    blocks = self.parse code, print_tokens
    blocks.map do |comment_block|
      comment_block.join "\n"
    end
  end
end
