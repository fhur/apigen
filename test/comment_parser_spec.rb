require 'minitest/autorun'
require './lib/lang/comment_parser.rb'


describe CommentParser do

  before :each do
    @parser = CommentParser.new
  end

  describe "parse" do

    it "should parse single comment lines" do
      code = """
      # comment line
      """
      tokens = @parser.parse code
      tokens.must_equal [
          [" comment line"]
      ]
    end

    it "should parse single comment empty lines" do
      code = """
      #
      """
      tokens = @parser.parse code
      tokens.must_equal [
        [""]
      ]
    end

    it "should ignore single line without comments" do
      code = """
      class A
        def initialize
        end
      end
      """
      tokens = @parser.parse code
      tokens.must_equal []
    end

    it "should include all lines with comments" do
      code = """
      # foo bar
      # baz
      #
      # fee fie
      # foe fum
      """
      tokens = @parser.parse(code)
      tokens.must_equal [
        [" foo bar", " baz", "", " fee fie", " foe fum"]
      ]

    end

    it "should delimit comment blocks" do
      code = """
      # block 1
      def method
      end

      # block 2
      # second line
      def method2
        # block 3
      end

      """
      tokens = @parser.parse code
      tokens.must_equal [
        [" block 1"],
        [" block 2", " second line"],
        [" block 3"]
      ]
    end

  end

end
