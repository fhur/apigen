require_relative './header.rb'
require_relative './http_method.rb'
require_relative './path_param.rb'
require_relative './query_param.rb'

class Endpoint

  # the type of request, can be one of
  # :simple, :multipart or :form_url_encoded
  attr_reader :request_type

  # The method or http verb, an instance of HttpMethod
  attr_reader :method

  # The request url. It can contain path params.
  # Example: /users/{user_id}/show
  attr_reader :url

  # Path params are obtained by parsing the url.
  # All params are delimited by { and } so for example
  # /users/{user_id}/cars/{car_id}/show has 2 path_params
  # the first one is user_id and the second one is car_id
  # TODO: Implement type enforcing
  # You can optionally enforce the path_param's type using the
  # following syntax {param_name:type} where type can be one of
  # string, int, float, double or boolean
  attr_reader :path_params

  # Url params are those that belong to the url in the form of queries
  # i.e. /users?user_name=bob contains the user_name query param
  attr_reader :query_params

  # A map of header names to Header objects. Each header is an http header key/value pair
  attr_reader :headers

  # a readable identifier for this endpoint (in underscored_lower_case format)
  # i.e. register_users
  attr_reader :name

  # A map of parameters
  attr_reader :request_params

  # Initializes a new endpoint
  # @param {String} name
  # @param {String} url
  # @param {HttpMethod} method the http method
  def initialize(name: require_name, url: require_url, method: HttpMethod.get)

    @name = name
    @url = url
    @method = method

    @path_params = PathParam.fromUrl(@url)
    @query_params = {}
    @headers = {}
    @request_params = {}

  end

  # Adds or updates a header if already present.
  # @param {Header} a header object
  def put_header(header)
    @headers[header.name] = header
  end

  # adds or updates a query param if already present.
  # @param {QueryParam} a query param object
  def put_query_param(query_param)
    @query_params[query_param.name] = query_param
  end

  # adds or updates a path param if already present.
  # @param {PathParam} a path param object.
  def put_path_param(path_param)
    raise ArgumentError, "Path params must be present in the URL: #{@url}" unless @path_params.include? path_param.name
    @path_params[path_param.name] = path_param
  end

  # adds or updates a request param if already present.
  def put_request_params(request_param)
    @request_params[request_param.name] = request_param
  end

  # returns the values of the @path_params hash as an array
  def path_params_list
    @path_params.values
  end

  # returns the values of the @query_params hash as an array
  def query_params_list
    @query_params.values
  end

  # returns the values of the @headers hash as an array
  def headers_list
    @headers.values
  end

end

