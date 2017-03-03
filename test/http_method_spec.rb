require 'minitest/autorun'
# require './lib/apigen/http_method.rb'
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apigen'
describe HttpMethod do

  describe ':get' do
    get = HttpMethod.get
    it 'should not have body' do
      get.has_body.must_equal false
    end

    it 'has :get as name' do
      get.name.must_equal :get
    end
  end

  describe ':post' do
    post = HttpMethod.post
    it 'should have body' do
      post.has_body.must_equal true
    end

    it 'has :post as name' do
      post.name.must_equal :post
    end

  end

  describe ':put' do
    put = HttpMethod.put
    it 'should have body' do
      put.has_body.must_equal true
    end

    it 'has :put as name' do
      put.name.must_equal :put
    end
 end

  describe ':delete' do
    delete = HttpMethod.delete
    it 'should not have body' do
      delete.has_body.must_equal false
    end

    it 'has :delete as name' do
      delete.name.must_equal :delete
    end

  end

  describe "create" do
    it "should return the correct method" do
      HttpMethod.create(:get).must_equal HttpMethod.get
      HttpMethod.create(:post).must_equal HttpMethod.post
      HttpMethod.create(:put).must_equal HttpMethod.put
      HttpMethod.create(:delete).must_equal HttpMethod.delete
    end
  end

end

