class Generator

  attr_accessor :endpoints

  def initialize
    # todo
    @endpoints = []
  end

  def add_endpoint(endpoint)
    @endpoints.push endpoints
  end

end

class Endpoint

  INIT_PATH_SEPARATOR = '{{'
  END_PATH_SEPARATOR = '}}'
  TOKEN_TYPE_SEPARATOR = ':'

  # the type of request, can be one of
  # :simple, :multipart or :form_url_encoded
  attr_reader :request_type

  # The method or http verb, can be one of
  # :get, :post, :put, :delete
  attr_reader :method

  # The request url. It can contain path params.
  # Example: /users/{{user_id}}/show
  attr_reader :url

  # Path params are obtained by parsing the url.
  # All params are delimited by {{ and }} so for example
  # /users/{{user_id}}/cars/{{car_id}}/show has 2 path_params
  # the first one is user_id and the second one is car_id
  # TODO: Implement type enforcing
  # You can optionally enforce the path_param's type using the
  # following syntax {{param_name:type}} where type can be one of
  # string, int, float, double or boolean
  attr_reader :path_params

  # Url params are those that belong to the url in the form of queries
  # i.e. /users?user_name=bob contains the user_name query param
  attr_reader :query_params
  attr_reader :headers
  attr_reader :fields
  attr_reader :name
  attr_reader :docs

  def initialize(name: nil, url: nil, method: :get)
    verify_not_nil [name, url]

    # A unique human readable identifier for the endpoint i.e. register_user
    @name = name

    # Each query param maps to the parameter's type i.e.
    # query_params[:name] = :string implies that the type of parameter
    # :name is :string.
    # They are initially initialized empty
    @query_params = {}

    # The enpoint's URL takes the following form
    #   /part[1]/part[2]/.../part[n]
    # Where part[i] is either string or {{string}}.
    # If part[i] == {{string}} for some string then it implies that
    # part[i] is a path parameter.
    #
    # By default all path parameters are string. If you would like to enforce
    # that a given path parameter be a number you can do so with the following syntax:
    # /users/{{user_id:number}}/show
    @url = url

    # Create the path parameters hash from the url.
    # path_params is a hash that maps a path parameter's
    # name to it's type. By default types are string.
    @path_params = parse_path_params(@url)

    # method must be one of :get, :post, :put, :options, :head, :delete
    @method = method

    # A map of headers. Maps header name to it's value.
    @headers = {}

    # A map of field names.
    @fields = {}

    # documentation for this endpoint. A short string briefly describing the endpoint.
    @docs = ''

  end

  def put_field(field, type = :string)
    raise ArgumentError, "field #{field} must be of type String" unless String == field.class
    @fields[field] = type
  end

  def put_header(header, value)
    @headers[header] = value
  end

  def put_query(name, value)
    @query_params[name] = value
  end

  # Given a url, it will return all path params in the url
  # Path params are expressed via {{param_name}} notation and
  # can optionally include a type using {{param_name:type}} notation.
  # The param_name can be any alphanumeric string starting
  # wth letters. The type can be one of :int, :string
  def parse_path_params(url)
    path_params = {} # create an empty hash that will hold the path params
    # tokens will hold an array of {{string}} elements
    tokens = url.gsub(/#{INIT_PATH_SEPARATOR}[a-zA-Z0-9]+(:[a-zA-Z0-9]+)?#{END_PATH_SEPARATOR}/).to_a
    tokens.each do |token|
      token_data = parse_path_param_token(token)
      token_name = token_data[0]
      token_type = token_data[1]
      path_params[token_name] = token_type
    end
    return path_params
  end

  # given a token {{token_string}}, this method will return the tokens name and type in an array
  # Example:
  #   {{user_id}} will return ["user_id", :string]
  #   {{user_id:int}} will return ["user_id", :int]
  def parse_path_param_token(token)
    token = token.delete(INIT_PATH_SEPARATOR).delete(END_PATH_SEPARATOR)
    if token.include? TOKEN_TYPE_SEPARATOR
      return token.split(TOKEN_TYPE_SEPARATOR)
    end
    return [token, :string]
  end

  def verify_not_nil(fields)
    fields.each do |field|
      raise ArgumentError, "field #{field} cannot be nil" if field.nil?
    end
  end
end

