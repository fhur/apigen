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

    it "should compile groups of endpoints" do
      code = """
      # post /user
      # @name foo
      def some_method()
        User.method_some
      end

      # get /fee
      # @name bar
      def some_method()
        User.method_some
      end

      """

      endpoint_group = @compiler.compile code, "name"
      endpoint_group.size.must_equal 2
      first = endpoint_group.endpoints.first
      second = endpoint_group.endpoints[1]
      first.method.name.must_equal :post
      second.method.name.must_equal :get
      first.url.must_equal "/user"
      second.url.must_equal "/fee"
    end

    it "should ignore simple comments that do not describe an endpoint" do
      code = """
      # this method does something cool
      def some_method
        method_cool()
      end
      """
      endpoint_group = @compiler.compile code, "name"
      endpoint_group.size.must_equal 0
    end

    it "should ignore inner comments" do
      code = """
      # post /user
      # @name foo
      def some_method()
        # foo bar
        User.method_some
      end

      # get /fee
      # @name bar
      def some_method()
        # bar baz
        User.method_some
      end

      """

      endpoint_group = @compiler.compile code, "name"
      endpoint_group.size.must_equal 2
      first = endpoint_group.endpoints.first
      second = endpoint_group.endpoints[1]
      first.method.name.must_equal :post
      second.method.name.must_equal :get
      first.url.must_equal "/user"
      second.url.must_equal "/fee"
    end

  end

end
