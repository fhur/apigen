require 'mustache'
require_relative './../../endpoint.rb'

class HTTPartyEndpoint < Endpoint

  # returns a comma separated list of all parameters
  # including path, query and request parameters
  def parameters
    parameters = []
    parameters += path_params.keys
    parameters += query_params.keys
    parameters += request_params.keys
    parameters.join ','
  end

  # given a url with params like
  # /users/{user_id}/friends/{friend_id}
  # this method will return
  # /users/#{user_id}/friends/#{friend_id}
  def formatted_url
    formatted_url = @url.dup
    @path_params.each do |name, path_param|
      formatted_url = formatted_url.gsub "{#{name}}", "\#{#{name}}"
    end
    return formatted_url
  end

  def query_hash
    hashes = @query_params.map do |name, query_param|
      ":#{query_param.name} => #{query_param.name}"
    end
    hashes.join(',')
  end

  def header_hash
     hashes = @headers.map do |name, header|
      ":#{header.name} => '#{header.value}'"
    end
    hashes.join(',')
  end

end
