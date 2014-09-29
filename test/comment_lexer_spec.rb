require 'minitest/autorun'
require './lib/lang/comment_lexer.rb'

describe CommentLexer do

  describe "ruby comments" do
    before :each do
      @lexer = CommentLexer.new start_regex: /\A(=begin)/, line_regex: /\A(#)/, end_regex: /\A(=end)/
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
        [:COMMENT_LINE, "#"], [:IDENTIFIER,"foo"],
        [:COMMENT_LINE, "#"], [:IDENTIFIER,"bar"], [:IDENTIFIER,"baz"],
        [:COMMENT_LINE, "#"], [:IDENTIFIER,"baz"],
        [:IDENTIFIER, "def"], [:IDENTIFIER, "some_method()"],
        [:IDENTIFIER, "end"],
        [:COMMENT_LINE, "#"], [:IDENTIFIER,"fee"],
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
        [:IDENTIFIER, "def"], [:IDENTIFIER, "some_method(arg)"],
        [:COMMENT_LINE, "#"], [:IDENTIFIER, "this"], [:IDENTIFIER, "method"], [:IDENTIFIER, "does"], [:IDENTIFIER, "something"],
        [:IDENTIFIER, "end"]
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
