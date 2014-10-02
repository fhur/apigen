

# Grammar for the Parser generator

class CommentParser

  token COMMENT_LINE
  token COMMENT_START
  token COMMENT_END
  token IDENTIFIER
  token COMMENT
  token NEW_LINE
  token EOF

rule

  program           : /* nothing */ { result = [] }
                    | expressions   { result = val }
                    ;

  expressions       : expressions comment { result = val[0] << val[1] }
                    | comment { result = val }
                    | expressions IDENTIFIER { result = val[0] }
                    | expressions NEW_LINE { result = val[0] }
                    ;

  comment           : COMMENT_START COMMENT COMMENT_END { result = val[1] }
                    | COMMENT_LINE COMMENT NEW_LINE { result = val[1] }
                    | COMMENT_LINE COMMENT EOF { result = val[1] }



---- header

  require "./lib/lang/comment_lexer.rb"

---- inner

  def parse(code, show_tokens=false)
    @tokens = CommentLexer.new.tokenize(code) # Tokenize the code using our lexer
    puts @tokens.inspect if show_tokens
    do_parse # Kickoff the parsing process
  end

  def next_token
    @tokens.shift
  end





