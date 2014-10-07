require './lib/lang/apigen_compiler.rb'
require 'minitest/autorun'

describe ApigenCompiler do


  before :each do
    @compiler = ApigenCompiler.new
  end

  describe "compile" do

    it "should compile simple endpoints" do
      code = """
      # post /users/{user_id}/foo/bar/{baz}
      # @name somename
      # @path {string} user_id
      # @path {boolean:optional} baz
      """

      endpoint_group = @compiler.compile code, "users"
      endpoint_group.name.must_equal "users"
      endpoints = endpoint_group.endpoints
      endpoints.size.must_equal 1
      endpoint = endpoints.first
      endpoint.url.must_equal "/users/{user_id}/foo/bar/{baz}"
      endpoint.name.must_equal "somename"
      endpoint.path_params.size.must_equal 2
      endpoint.path_params[:user_id].name.must_equal :user_id

    end

  end

end
