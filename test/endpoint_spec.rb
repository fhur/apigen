require 'minitest/autorun'
# require './lib/apigen/endpoint.rb'
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apigen'
describe Endpoint do

  before :all do
    @endpoint = Endpoint.new name: 'foo', url: '/foo/{id}'
    @query = QueryParam.new name: 'foo-query', type: :string
    @path = PathParam.new name: 'sort', type: :boolean
    @header = Header.new name: 'Content-Type', value: 'application/json'
  end

  it "should have method get by default" do
    @endpoint.method.must_equal HttpMethod.get
  end

  describe "put_query_param" do

    it "should add a new query" do
      @endpoint.put_query_param @query
      @endpoint.query_params.must_include @query.name
      @endpoint.query_params[@query.name].must_equal @query
    end

    it "should not allow repeated queries" do
      10.times do
        @endpoint.put_query_param @query
        @endpoint.query_params.size.must_equal 1
      end
    end
  end

  describe "put_header" do

     it "should add a new header" do
      @endpoint.put_header @header
      @endpoint.headers.must_include @header.name
      @endpoint.headers[@header.name].must_equal @header
    end

    it "should not allow repeated headers" do
      10.times do
        @endpoint.put_header @header
        @endpoint.headers.size.must_equal 1
      end
    end
  end

  describe "put_path_param" do
    it "should not allow adding path params not present in the url" do
      assert_raises ArgumentError do
        @endpoint.put_path_param PathParam.new name: 'qwer', type: :string
      end
    end
  end

end
