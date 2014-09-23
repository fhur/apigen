class Lexer

  KEYWORDS = [
    "@param",
    "@query",
    "@header",
    "@path"
  ]

  TYPES = [
    "string",
    "int",
    "boolean",
    "float"
  ]

  METHODS = [
    "get",
    "put",
    "post",
    "delete"
  ]

  def tokenize(code)
    code.chomp!
    tokens = [] # every token is a [:name, :value] pair
    # TODO implement tokenize
    return tokens
  end

end
