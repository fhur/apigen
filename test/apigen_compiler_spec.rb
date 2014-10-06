require './lib/lang/apigen_compiler.rb'
require 'minitest/autorun'

describe ApigenCompiler do


  before :each do
    @compiler = ApigenCompiler.new
  end

  describe "compile" do

    it "should compile simple endpoints" do
      code = """
      get /users/{user_id}
      @name get_user
      """
      endpoint_group = @compiler.compile code, "users"
      endpoint_group.name.must_equal "users"
      endpoints = endpoint_group.endpoints
      endpoints.size.must_equal 1
      endpoints.first.method.must_equal HttpMethod.get
      endpoints.first.url.must_equal "/users/{user_id}"
      endpoints.first.name.must_equal "get_user"

    end

  end

end
