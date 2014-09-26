

# Grammar for the Parser generator

class Parser

  token PARAM
  token QUERY
  token PATH
  token HEADER
  token OPTIONAL
  token TYPE
  token METHOD
  token URL
  token COLON
  token BRACE
  token IDENTIFIER

rule

  program           : /* nothing */ { result = Nodes.new([]) }
                    | expressions   { result = val[0] }
                    ;

  expressions       : method_with_url { result = val }
                    | method_with_url param_list { result = val }
                    ;

  param_list        : param { result = val }
                    | param_list param { result = val[0] << val[1] }
                    ;

  param             : path_param { result = val }
                    | query_param { result = val }
                    | header_param { result = val }
                    ;

  type_structure    : BRACE TYPE BRACE { result = TypeNode.new val[1], true }
                    | BRACE TYPE COLON OPTIONAL BRACE { result = TypeNode.new [1], false }
                    ;

  path_param        : PATH type_structure IDENTIFIER { result = PathParam.new(val[1], val[2]) }
                    ;

  query_param       : QUERY type_structure IDENTIFIER { result = QueryNode.new(val[1], val[2]) }
                    ;

  header_param      : HEADER IDENTIFIER IDENTIFIER { result = HeaderNode.new(val[1], val[2]) }
                    ;

  method_with_url   : METHOD URL { result = UrlMethod.new val[0], val[1] }
                    ;


---- header

  require "./lib/lang/nodes.rb"
  require "./lib/lang/lexer.rb"

---- inner

  def parse(code, show_tokens=false)
    puts "parsing"
    @tokens = Lexer.new.tokenize(code) # Tokenize the code using our lexer
    puts @tokens.inspect if show_tokens
    do_parse # Kickoff the parsing process
  end

  def next_token
    @tokens = [] unless @tokens
    @tokens.shift
  end





