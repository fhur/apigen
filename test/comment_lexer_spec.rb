require 'minitest/autorun'
require './lib/lang/comment_lexer.rb'

describe CommentLexer do

  describe "ruby comments" do

    before :each do
      @lexer = CommentLexer.new start_regex: /\A(=begin)/, line_regex: /\A(#)/, end_regex: /\A(=end)/
    end

    it "should recognize single comment lines" do
      code = "# single comment line"
      tokens = @lexer.tokenize code
      tokens.must_equal [
        [:COMMENT_LINE, "#"], [:COMMENT, " single comment line"],
        [:EOF, 'eof']
      ]
    end

    it "should recognize empty comment lines" do
      code = """
      #
      # some comment here
      #
      # some other comment here
      """
      tokens = @lexer.tokenize(code)
      tokens.must_equal [
        [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'],[:COMMENT, ""], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " some comment here"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'],[:COMMENT, ""], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " some other comment here"], [:NEW_LINE, 'n'],
        [:EOF, 'eof']
     ]
    end

    it "should recognize ruby comments" do
      code = """
      # foo
      # bar baz
      # baz
      def some_method()
      end
      # fee
      """

      tokens = @lexer.tokenize(code)
      tokens.must_equal [
        [:NEW_LINE, 'n'],
        [:COMMENT_LINE, "#"], [:COMMENT, " foo"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, "#"], [:COMMENT, " bar baz"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, "#"], [:COMMENT, " baz"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, "def"], [:IDENTIFIER, "some_method()"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, "end"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, "#"], [:COMMENT, " fee"], [:NEW_LINE, 'n'],
        [:EOF, 'eof']
      ]
    end

    it "should recognize comments inside methods" do
      code = """
      def some_method(arg)
        # this method does something
      end
      """
      tokens = @lexer.tokenize code
      tokens.must_equal [
        [:NEW_LINE, 'n'],
        [:IDENTIFIER, "def"], [:IDENTIFIER, "some_method(arg)"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, "#"], [:COMMENT, " this method does something"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, "end"], [:NEW_LINE, 'n'],
        [:EOF, 'eof']
      ]
    end

    it "should tokenize new lines" do
      code = """
      # some comment
      # second line of that comment

      # some other comment
      # second line of that comment
      """
      tokens = @lexer.tokenize code
      tokens.must_equal [
        [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " some comment"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " second line of that comment"], [:NEW_LINE, 'n'],
        [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " some other comment"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " second line of that comment"], [:NEW_LINE, 'n'],
        [:EOF, 'eof']
      ]
    end

    it "should tokenize new lines after identifiers" do
      code = """
      # some comment line
      def some_code_here
      end

      # some other comment line
      # last comment line
      def last_code_here
      end
      """
      tokens = @lexer.tokenize code
      tokens.must_equal [
        [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " some comment line"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, "def"], [:IDENTIFIER, "some_code_here"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, "end"], [:NEW_LINE, 'n'],
        [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " some other comment line"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " last comment line"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, "def"], [:IDENTIFIER, "last_code_here"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, "end"], [:NEW_LINE, 'n'],
        [:EOF, 'eof']
      ]
    end

    it "should tokenize multi line comments" do
      code = """
      # first line
      # second line
      # this is the third line
      # last line
      def some_method()
        puts 'method'
      end

      # some documentation here
      # and some more here
      # last line of doc
      def some_other_method()
        some_method()
      end
      """
      tokens = @lexer.tokenize code
      tokens.must_equal [
        [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " first line"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " second line"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " this is the third line"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " last line"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, "def"], [:IDENTIFIER, "some_method()"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, 'puts'], [:IDENTIFIER, "'method'"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, 'end'], [:NEW_LINE, 'n'],
        [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " some documentation here"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " and some more here"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, '#'], [:COMMENT, " last line of doc"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, 'def'],  [:IDENTIFIER, 'some_other_method()'], [:NEW_LINE, 'n'],
        [:IDENTIFIER, 'some_method()'], [:NEW_LINE, 'n'],
        [:IDENTIFIER, 'end'], [:NEW_LINE, 'n'],
        [:EOF, 'eof']
      ]

    end

  end

  describe "java comments" do
    # TODO
  end

  describe "python comments" do
    # TODO
  end

  describe "php comments" do
    # TODO
  end

end
