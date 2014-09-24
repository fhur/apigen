

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

  expressions       : method_with_url
                    | method_with_url param_list
                    ;

  param_list        : param
                    | param_list param
                    ;

  param             : path_param
                    | query_param
                    | header_param
                    ;

  type_structure    : BRACE IDENTIFIER BRACE
                    | BRACE IDENTIFIER COLON OPTIONAL BRACE
                    ;

  path_param        : PATH type_structure IDENTIFIER
                    ;

  query_param       : QUERY type_structure IDENTIFIER
                    ;

  header_param      : HEADER IDENTIFIER IDENTIFIER
                    ;

  method_with_url   : METHOD URL
                    ;





