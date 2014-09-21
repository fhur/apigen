require 'minitest/autorun'
require './lib/plugins/httparty/httparty_endpoint.rb'

describe HTTPartyEndpoint do

  HASH_REGEX = /:[a-zA-Z]+(_[a-zA-Z]+)? => [a-zA-Z]+(_[a-zA-Z]+)?(, :[a-zA-Z]+(_[a-zA-Z]+)? => [a-zA-Z]+(_[a-zA-Z]+)?)?/
  COMMA_SEPARATER_REGEX = /[a-zA-Z]/

  before :each do
    @endpoint = HTTPartyEndpoint.new name: 'foo_method', url: '/foo/{bar}/{baz}/fee'
    @endpoint.put_query_param QueryParam.new name: 'fie'
    @endpoint.put_query_param QueryParam.new name: 'fum'
  end

  describe 'formatted_url' do
    it 'returns a ruby interpolated string' do
      @endpoint.formatted_url.must_equal '/foo/#{bar}/#{baz}/fee'
    end
  end

  describe 'query_hash' do
    it 'returns a ruby-syntax hash ' do
      # this regex looks for :word => word(, :word => word)?
      @endpoint.query_hash.must_match HASH_REGEX
    end

    it 'contains commas equal to size -1' do
      @endpoint.query_hash.gsub(',').to_a.size.must_equal(@endpoint.query_params.size-1)
    end
  end

  describe 'parameters' do
    it 'should contain the name of all parameters' do
      params = @endpoint.parameters
      ['bar', 'baz', 'fie', 'fum'].each do |param|
        params.must_include param
      end
    end

    it 'should contain all parameters separater by comma' do
      @endpoint.parameters.split(',').size.must_equal 4
    end
  end

end
