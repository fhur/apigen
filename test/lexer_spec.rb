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
        [:@QUERY, "@query"], ["{"], [:TYPE, "string"], ["}"], [:IDENTIFIER, "user_id"], [:IDENTIFIER, "comments"]
      ]
    end

    it "should recognize optional types" do
      tokens = @lexer.tokenize("@query {string:optional} user_id comments")
      tokens.must_equal [
        [:@QUERY, "@query"], ["{"], [:TYPE, "string"], [':'], [:OPTIONAL, "optional"], ["}"], [:IDENTIFIER, "user_id"], [:IDENTIFIER, "comments"]
      ]
    end

    it "should recognize optional comments" do
      tokens = @lexer.tokenize("@query {string} user_id")
      tokens.must_equal [
        [:@QUERY, "@query"], ["{"], [:TYPE, "string"], [':'], [:OPTIONAL, "optional"], ["}"], [:IDENTIFIER, "user_id"]
      ]
    end
  end

  describe "path params" do
    it "should recognize path params" do
      tokens = @lexer.tokenize("@param {boolean} is_registered comments")
      tokens.must_equal [
        [:@PARAM, "@param"], ["{"], [:TYPE, "boolean"], ["}"], [:IDENTIFIER, "is_registered"], [:IDENTIFIER, "comments"]
      ]
    end
  end
end
