class Nodes < Struct.new :nodes

  # returns an array with all nodes of type QueryNode
  def query_nodes
    get_nodes type: QueryNode
  end

  # returns an array with all nodes of type HeaderNode
  def header_nodes
    get_nodes type: HeaderNode
  end

  # returns an array with all nodes of type PathNode
  def path_nodes
    get_nodes type: PathNode
  end

  # returns a NameNode, there should only be one. In case
  # there are mre than one, the result is not guaranteed
  # to be correct
  def name_node
    get_nodes(type: NameNode).first
  end

  # Iterates through the Nodes structure and returns all
  # nodes with the given type
  def get_nodes(type: nil)
    nodes[1]
      .map { |i| i.first }
      .select { |node| node.is_a? type }
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

class NameNode < Struct.new  :name; end


