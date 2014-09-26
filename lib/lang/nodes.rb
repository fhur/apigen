class Nodes < Struct.new :nodes

  def query_nodes
    get_nodes type: QueryNode
  end

  def header_nodes
    get_nodes type: HeaderNode
  end

  def path_nodes
    get_nodes type: PathNode
  end

  def get_nodes(type:nil)
    nodes[1].select { |i| i.first.is_a? type }
  end

  def url_method
    nodes.first
  end

end

class TypeNode < Struct.new :type, :required; end

class QueryNode < Struct.new :type, :name; end

class HeaderNode < Struct.new :name, :value; end

class UrlMethod < Struct.new :method, :url; end

class PathNode < Struct.new :type, :name; end


