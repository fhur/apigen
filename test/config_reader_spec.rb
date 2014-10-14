require 'minitest/autorun'
require './lib/config/config_reader.rb'

describe ConfigReader do

  before :each do
    @empty = {
      'endpoints' => []
    }

    @single = {
      'endpoints' => [
        {
          'require' => 'apigen',
          'out' => './pkg/out_file.txt',
          'class' => 'SimpleGenerator'
        }
      ]
    }
  end

  describe "parsing json" do

    it "should parse empty endpoint lists " do
      endpoints = ConfigReader.new(@empty).endpoints
      endpoints.size.must_equal 0
    end
  end

end
