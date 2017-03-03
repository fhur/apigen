require 'minitest/autorun'
# require './lib/apigen/endpoint_group.rb'
# require './lib/apigen/endpoint.rb'
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apigen'
describe EndpointGroup do

  before :each do
    @endpoint = Endpoint.new name: 'name', url: 'foo/bar', method: HttpMethod.get
  end

  describe "initialize" do

    it "should set opts" do
      opts = {1=>2, :a=>'foo'}
      group = EndpointGroup.new opts: opts
      group.opts.must_equal opts
    end

    it "should set endpoints" do
      endpoints = [@endpoint]
      group = EndpointGroup.new endpoints: endpoints
      group.endpoints.must_equal endpoints
    end
  end

  describe "add" do

    before :each do
      @endpoint_group = EndpointGroup.new
    end

    it "should add an endpoint" do
      size = @endpoint_group.size
      @endpoint_group.add @endpoint
      @endpoint_group.size.must_equal(size+1)
      @endpoint_group.endpoints.include?(@endpoint).must_equal true
    end

  end

  describe "get_binding" do

    it "should return a non null result" do
      endpoint_group = EndpointGroup.new
      endpoint_group.get_binding.wont_be_nil
    end
  end


end
