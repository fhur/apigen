require 'minitest/autorun'
require './lib/endpoint_group.rb'
require './lib/endpoint.rb'

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


end
