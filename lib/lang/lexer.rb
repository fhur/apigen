class Lexer

  KEYWORDS = [
    "@param",
    "@query",
    "@header",
    "@path",
    "optional"
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

  def to_identifier(str)
    str.upcase.to_sym
  end

  def tokenize(code)
    code.chomp!
    tokens = [] # every token is a [:name, :value] pair
    i = 0 # hold the current index
    while i < code.size
      chunk = code[i..-1]

      # First we will match all keywords
      # i.e. @query, @param, @header, @path
      if keyword = chunk[/\A(#{KEYWORDS.join("|")})/, 1]
        tokens << [to_identifier(keyword), keyword]
        i += keyword.size

      # Now we match http methods
      # get, post, put, delete, etc.
      elsif method = chunk[/\A(#{METHODS.join("|")})/, 1]
        tokens << [:METHOD, method]
        i += method.size

      # Now we match urls
      # Urls are all strings starting
      # with / up to the last non whitespace character
      elsif url = chunk[/\A(\/(\S+))/, 1]
        tokens << [:URL, url]
        i += url.size

      # Now we match types
      # string, int, boolean, float
      elsif type = chunk[/\A(#{TYPES.join("|")})/, 1]
        tokens << [:TYPE, type]
        i += type.size

      elsif colon = chunk[/\A(:)/, 1]
        tokens << [:COLON, colon]
        i += colon.size

      # match { and }
      elsif brace = chunk[/\A({|})/, 1]
        tokens << [:BRACE, brace]
        i += brace.size

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
