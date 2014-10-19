require 'minitest/autorun'
require './lib/apigen/generation/generator.rb'


describe Generator do

  before :each do
    @generator = Generator.new
  end

  describe "generate" do

    it "should throw an error indicating that it must be overriden" do
      assert_raises NotImplementedError do
        @generator.generate([])
      end
    end
  end

end
