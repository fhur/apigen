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

  describe "parse_and_join" do

    it "should recognize empty code" do
      comments = @parser.parse_and_join ""
      comments.must_equal []
    end

    it "should recognize empty comments" do
      comments = @parser.parse_and_join "#"
      comments.must_equal [""]
    end

    it "should recognize empty separate blocks" do
      code = """
      #

      #

      #
      """
      comments = @parser.parse_and_join code
      comments.must_equal ["","",""]
    end

    it "should recognize single line comments" do
      code = """
      # this is a comment line
      """
      comments = @parser.parse_and_join code
      comments.must_equal [" this is a comment line"]
    end

    it "should recognize multi line comments" do
      code = """
      # this is a comment line
      # this one two
      """
      comments = @parser.parse_and_join code
      comments.must_equal [" this is a comment line\n this one two"]
    end

    it "should recognize multi line blocks of comments" do
      code = """
      # this is a comment line
      # this one two

      # this is another comment
      """
      comments = @parser.parse_and_join code
      comments.must_equal [
        " this is a comment line\n this one two",
        " this is another comment"
      ]
    end

    it "should ignore identifiers in mlti line blocks of comments " do
      code = """
      # get /users/{user_id}
      # @name create_user
      # @header Content-Type application/json
      # @query {string} name
      def create_user
        # creates a new user
        User.create(params)
      end

      # post /users
      # @name creates_user
      def method_impl_fake_here
        User.fake.stuff
      end
      """
      comments = @parser.parse_and_join code
      comments.must_equal [
      " get /users/{user_id}\n @name create_user\n @header Content-Type application/json\n @query {string} name",
      " creates a new user",
      " post /users\n @name creates_user"
      ]

    end


  end

end
