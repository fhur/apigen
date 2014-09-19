class PathParam

  INIT_PATH_SEPARATOR = '{{'
  END_PATH_SEPARATOR = '}}'
  TOKEN_TYPE_SEPARATOR = ':'

  attr_accessor :name
  attr_accessor :type

  def initialize(name: force_name, type: :string)
    @name, @type = name, type
  end

  # Given a url, it will return all path params in the url
  # Path params are expressed via {{param_name}} notation and
  # can optionally include a type using {{param_name:type}} notation.
  # The param_name can be any alphanumeric string starting
  # wth letters. The type can be one of :int, :string
  def PathParam.fromUrl(url)
    path_params = {} # create an empty hash that will hold the path params
    # tokens will hold an array of {{string}} elements
    tokens = url.gsub(/#{INIT_PATH_SEPARATOR}[a-zA-Z0-9]+(:[a-zA-Z0-9]+)?#{END_PATH_SEPARATOR}/).to_a
    tokens.each do |token|
      path_param = PathParam.parse_path_param_token(token)
      path_params[path_param.name] = path_param
    end
    return path_params
  end

  # given a token {{token_string}}, this method will return the tokens name and type in an array
  # Example:
  #   {{user_id}} will return ["user_id", :string]
  #   {{user_id:int}} will return ["user_id", :int]
  def PathParam.parse_path_param_token(token)
    token = token.delete(INIT_PATH_SEPARATOR).delete(END_PATH_SEPARATOR)
    name = token
    type = :string # by default
    if token.include? TOKEN_TYPE_SEPARATOR
      attrs = token.split(TOKEN_TYPE_SEPARATOR)
      name, type = attrs[0], attrs[1]
    end
    return PathParam.new(name: name.to_sym, type: type.to_sym)
  end


end


