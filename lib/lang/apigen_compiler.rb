require './lib/endpoint.rb'
require './lib/lang/parser.tab.rb'
require './lib/lang/nodes.rb'
require './lib/lang/path_param.rb'
require './lib/lang/header.rb'
require './lib/lang/query_param.rb'
require './lib/lang/request_param.rb'

class ApigenCompiler

  def initialize()
    @parser = Parser.new
  end

  def compile(code, endpoint_name="")
    nodes = @parser.parse(code)
    url_method_node = nodes.first
    params = nodes[1]
    if params
      params.each do |node_param|
        param = get_param(node_param)
      end
    end
    return Endpoint.new method: url_method_node.method, url: url_method_node.url, name: endpoint_name
  end

  def get_param(node_param)
    if param.is_a? QueryNode
      QueryParam.new name: param.name, type: param.type
    elsif param.is_a? HeaderNode
      Header.new name: param.name, value: param.value
    elsif param.is_a? PathNode
      PathParam.new name: param.name, type: param.type
    else
      raise "Unrecognized #{node_param}"
    end
  end

end
