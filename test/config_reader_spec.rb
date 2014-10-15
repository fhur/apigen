require 'minitest/autorun'
require './lib/config/config_reader.rb'
require './lib/generation/simple_generator.rb'

describe ConfigReader do

  before :each do
    @empty = {
      'endpoints' => []
    }

    @single = {
      'endpoints' => [
        {
          'input' => 'some/file.rb',
          'generators' => [
            {
              'require' => './lib/generation/simple_generator.rb',
              'out' => './pkg/out_file.txt',
              'class' => 'SimpleGenerator'
            }
          ]
        }
      ]
    }

    @multiple = {
      'endpoints' => [
        {
          'input' => 'foo.rb',
          'generators' => [
            {
              'require' => './lib/generation/simple_generator.rb',
              'out' => './foo/bar.md',
              'class' => 'SimpleGenerator'
            },
            {
              'require' => './lib/generation/simple_generator.rb',
              'out' => './foo/bar.rb',
              'class' => 'SimpleGenerator'
            }
          ]
        },
        {
          'input' => 'bar.rb',
          'generators' => [
            {
              'require' => './lib/generation/simple_generator.rb',
              'out' => './fee/fie.txt',
              'class' => 'SimpleGenerator'
            }
          ]
        }
     ]
    }


  end

  describe "parsing json" do

    it "should parse empty endpoint lists " do
      endpoints = ConfigReader.new(@empty).endpoints
      endpoints.size.must_equal 0
    end

    it "should parse single endpoint" do
      endpoints = ConfigReader.new(@single).endpoints

      # test the endpoint
      endpoints.size.must_equal 1
      endpoint = endpoints.first
      endpoint[:input].must_equal 'some/file.rb'
      endpoint[:generators].size.must_equal 1
      gen = endpoint[:generators].first

      # test the GeneratorWriter
      gen.path.must_equal './pkg/out_file.txt'
      gen.generator.wont_be_nil
      gen.generator.is_a? SimpleGenerator
      gen.opts.wont_be_nil
      gen.opts.size.must_equal 0
    end

    it "should parse several endpoints" do
      endpoints = ConfigReader.new(@multiple).endpoints

      # verify that there are 2 endpoints
      endpoints.size.must_equal 2
      endpoints.first[:generators].size.must_equal 2
      endpoints[1][:generators].size.must_equal 1
    end
  end

  describe "get_key" do

    before :each do
      @config = ConfigReader.new @single
      @hash = {
        :name => 'bob'
      }
    end

    it "should raise an error if the key is not present" do
      assert_raises RuntimeError do
        @config.get_key(@hash, :name2)
      end
    end

    it "should return the value of the key if present" do
      value = @config.get_key @hash, :name
      value.must_equal 'bob'
    end
  end

end
