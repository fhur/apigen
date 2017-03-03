# encoding: UTF-8

require 'minitest/autorun'
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apigen'

describe ApigenCompiler do
  describe 'compile simple endpoints' do
    it 'should compile simple endpoints' do
      code = "
      # post /users/{user_id}/foo/bar/{baz}
      # @name somename
      # @path {string} user_id
      # @path {boolean:optional} baz
      "
      @compiler = ApigenCompiler.new
      endpoint_group = @compiler.compile code, 'users'
      endpoints = endpoint_group.endpoints
      endpoints.size.must_equal 1
      endpoint = endpoints.first
      endpoint.url.must_equal '/users/{user_id}/foo/bar/{baz}'
      endpoint.name.must_equal 'somename'
      endpoint.path_params.size.must_equal 2
      endpoint.path_params[:user_id].name.must_equal :user_id
    end
  end
end

describe ApigenCompiler do
  describe 'compile groups of endpoints' do
    it 'should compile groups of endpoints' do
      code = "
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

      "
      @compiler = ApigenCompiler.new
      endpoint_group = @compiler.compile code, 'name'
      endpoint_group.size.must_equal 2
      first = endpoint_group.endpoints.first
      second = endpoint_group.endpoints[1]
      first.method.name.must_equal :post
      second.method.name.must_equal :get
      first.url.must_equal '/user'
      second.url.must_equal '/fee'
    end
  end
end

describe ApigenCompiler do
  describe 'ignore simple comments' do
    it 'should ignore simple comments that do not describe an endpoint' do
      code = "
      # this method does something cool
      def some_method
        method_cool()
      end
      "
      @compiler = ApigenCompiler.new
      endpoint_group = @compiler.compile code, 'name'
      endpoint_group.size.must_equal 0
    end
  end
end

describe ApigenCompiler do
  describe 'ignore inner comments' do
    it 'should ignore inner comments' do
      code = "
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

      "
      @compiler = ApigenCompiler.new
      endpoint_group = @compiler.compile code, 'name'
      endpoint_group.size.must_equal 2
      first = endpoint_group.endpoints.first
      second = endpoint_group.endpoints[1]
      first.method.name.must_equal :post
      second.method.name.must_equal :get
      first.url.must_equal '/user'
      second.url.must_equal '/fee'
    end
  end
end
