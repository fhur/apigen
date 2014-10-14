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
  end

end
