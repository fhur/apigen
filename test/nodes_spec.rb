require 'minitest/autorun'
require './lib/lang/parser.tab.rb'

describe Nodes do

  before :each do
    code = """
    post /users/{user_id}/show
    @name filter_users
    @query  {string}          foo
    @query  {string:optional} bar
    @path   {int}             user_id
    @header X-VERSION-NAME    1.0
    @header Content-Type      application/json
    """
    @nodes = Parser.new.parse(code)
  end

  describe "query_nodes" do

    it "should return an array of QueryNode" do
      nodes = [
        QueryNode.new(TypeNode.new("string", true), "foo"),
        QueryNode.new(TypeNode.new("string", false), "bar")
      ]
      @nodes.query_nodes.must_equal nodes
    end
  end

  describe "header_nodes" do
    it "should return an array of HeaderNode" do
      nodes = [
        HeaderNode.new("X-VERSION-NAME", "1.0"),
        HeaderNode.new("Content-Type", "application/json")
      ]
      @nodes.header_nodes.must_equal nodes
    end
  end

  describe "path_nodes" do
    it "should return an array of PathNode" do
      nodes = [
        PathNode.new(TypeNode.new("int", true), "user_id"),
      ]
      @nodes.path_nodes.must_equal nodes

    end
  end

  describe "name_node" do
    it "should return the NameNode" do
      @nodes.name_node.must_equal NameNode.new "filter_users"
    end
  end

  describe "url_method" do
    it "should return the UrlMethod node" do
      @nodes.url_method.must_equal UrlMethod.new "post", "/users/{user_id}/show"
    end
  end


end
