require 'minitest/autorun'
require './lib/lang/lexer.rb'

describe Lexer do

  before :each do
    @lexer = Lexer.new
  end

  it "should recognize types" do
    ["string", "int", "boolean", "float"].each do |type|
      @lexer.tokenize(type).must_equal [[:TYPE, type]]
    end
  end

  it "should recognize keywords" do
    ["@query", "@param", "@header", "@path"].each do |keyword|
      @lexer.tokenize(keyword).must_equal [[keyword.upcase.to_sym, keyword]]
    end
  end

  it "should recognize method" do
    ["get", "post", "put", "delete"].each do |keyword|
      @lexer.tokenize(keyword).must_equal [[:METHOD, keyword]]
    end
  end

  it "should recognize method and urls" do
    tokens = @lexer.tokenize("delete /users/{user_id}/friends/{friend_id}")
    tokens.must_equal [[:METHOD, "delete"],[:URL, "/users/{user_id}/friends/{friend_id}"]]
  end

  describe "query params" do
    it "should recognize @query params" do
      tokens = @lexer.tokenize("@query {string} user_id comments")
      tokens.must_equal [
        [:@QUERY, "@query"], ["{"], [:TYPE, "string"], ["}"], [:IDENTIFIER, "user_id"], [:IDENTIFIER, "comments"]
      ]
    end
  end

end
