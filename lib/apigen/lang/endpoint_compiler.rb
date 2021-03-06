require 'apigen/endpoint.rb'
require 'apigen/lang/parser.tab.rb'
require 'apigen/lang/nodes.rb'
require 'apigen/path_param.rb'
require 'apigen/header.rb'
require 'apigen/query_param.rb'
require 'apigen/request_param.rb'

class EndpointCompiler

  def initialize()
    @parser = Parser.new
  end

  def compile(code)
    nodes = @parser.parse(code)
    url_method_node = nodes.url_method
    method = HttpMethod.create(url_method_node.method.to_sym)
    url = url_method_node.url
    name = nodes.name_node.name
    endpoint = Endpoint.new url: url, method: method, name: name

    nodes.query_nodes.each do |query_node|
      type = query_node.type.type
      name = query_node.name.to_sym
      endpoint.put_query_param(QueryParam.new name: name, type: type)
    end

    nodes.path_nodes.each do |path_nodes|
      type = path_nodes.type.type
      name = path_nodes.name.to_sym
      endpoint.put_path_param(PathParam.new name: name, type: type)
    end

    nodes.header_nodes.each do |header_node|
      endpoint.put_header(Header.new name: header_node.name, value: header_node.value)
    end
    endpoint
  end

end
