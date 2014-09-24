require 'minitest/autorun'
require './lib/lang/lexer.rb'

describe Lexer do

  before :each do
    @lexer = Lexer.new
  end

  describe "types" do
    it "should recognize types" do
      ["string", "int", "boolean", "float"].each do |type|
        @lexer.tokenize(type).must_equal [[:TYPE, type]]
      end
    end
  end

  describe "keywords" do
    it "should recognize keywords" do
      ["@query", "@param", "@header", "@path"].each do |keyword|
        @lexer.tokenize(keyword).must_equal [[keyword.upcase.to_sym, keyword]]
      end
    end
  end

  describe "Method" do
    it "should recognize method" do
      ["get", "post", "put", "delete"].each do |keyword|
        @lexer.tokenize(keyword).must_equal [[:METHOD, keyword]]
      end
    end

    it "should recognize method and urls" do
      tokens = @lexer.tokenize("delete /users/{user_id}/friends/{friend_id}")
      tokens.must_equal [[:METHOD, "delete"],[:URL, "/users/{user_id}/friends/{friend_id}"]]
    end
  end

  describe "query params" do

    it "should recognize @query params" do
      tokens = @lexer.tokenize("@query {string} user_id comments")
      tokens.must_equal [
        [:@QUERY, "@query"], [:BRACE,"{"], [:TYPE, "string"], [:BRACE,"}"], [:IDENTIFIER, "user_id"], [:IDENTIFIER, "comments"]
      ]
    end

    it "should recognize optional types" do
      tokens = @lexer.tokenize("@query {string:optional} user_id comments")
      tokens.must_equal [
        [:@QUERY, "@query"], [:BRACE,"{"], [:TYPE, "string"], [:COLON, ':'], [:OPTIONAL, "optional"], [:BRACE,"}"], [:IDENTIFIER, "user_id"], [:IDENTIFIER, "comments"]
      ]
    end

    it "should recognize optional comments" do
      tokens = @lexer.tokenize("@query {string:optional} user_id")
      tokens.must_equal [
        [:@QUERY, "@query"], [:BRACE,"{"], [:TYPE, "string"], [:COLON,':'], [:OPTIONAL, "optional"], [:BRACE,"}"], [:IDENTIFIER, "user_id"]
      ]
    end
  end

  describe "path params" do
    it "should recognize path params" do
      tokens = @lexer.tokenize("@param {boolean} is_registered comments")
      tokens.must_equal [
        [:@PARAM, "@param"], [:BRACE,"{"], [:TYPE, "boolean"], [:BRACE,"}"], [:IDENTIFIER, "is_registered"], [:IDENTIFIER, "comments"]
      ]
    end
  end

  describe "complex scenario" do
    it "should tokenize multistrings" do
      code = """
      get /users/{user_id}/show
      @path {int} user_id The user's id
      @query {string} date
      @query {boolean:optional} sort
      @header Content-Type application/json
      """
      tokens = @lexer.tokenize(code)
      tokens.must_equal [
        [:METHOD, 'get'], [:URL,'/users/{user_id}/show' ],
        [:@PATH, "@path"], [:BRACE, "{"], [:TYPE, "int"], [:BRACE, "}"], [:IDENTIFIER, "user_id"], [:IDENTIFIER, "The"], [:IDENTIFIER, "user's"], [:IDENTIFIER, "id"],
        [:@QUERY, "@query"] , [:BRACE, "{"], [:TYPE, "string"], [:BRACE, "}"], [:IDENTIFIER, "date"],
        [:@QUERY, "@query"] , [:BRACE, "{"], [:TYPE, "boolean"], [:COLON, ":"], [:OPTIONAL, "optional"], [:BRACE, "}"], [:IDENTIFIER, "sort"],
        [:@HEADER, "@header"], [:IDENTIFIER, 'Content-Type'], [:IDENTIFIER, "application/json"]
      ]
    end
  end
end
