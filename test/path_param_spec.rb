require 'minitest/autorun'
# require './lib/apigen/path_param.rb'
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apigen'
describe PathParam do

  describe "fromUrl" do

    it "should return an empty map when no params are present" do
      PathParam.fromUrl('/foo/bar').must_be_empty
    end

    it "should return a map of params " do
      path_params = PathParam.fromUrl('/{{foo_bar}}/fum/{{bar}}-{{baz}}/fee')
      path_params.size.must_equal 3
      [:foo_bar,:bar,:baz].each do |attr|
        path_params[attr].wont_be_nil
        path_params[attr].name.must_equal attr
      end
    end

    it "recognizes the type accordingly using the {{name:type}} syntax" do
      path_params = PathParam.fromUrl('/{{foo:int}}/bar')
      path_params[:foo].type.must_equal :int
    end

  end
end
