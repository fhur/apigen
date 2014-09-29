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
        [:NEW_LINE, 'n'],
        [:COMMENT_LINE, "#"], [:IDENTIFIER,"foo"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, "#"], [:IDENTIFIER,"bar"], [:IDENTIFIER,"baz"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, "#"], [:IDENTIFIER,"baz"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, "def"], [:IDENTIFIER, "some_method()"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, "end"], [:NEW_LINE, 'n'],
        [:COMMENT_LINE, "#"], [:IDENTIFIER,"fee"], [:NEW_LINE, 'n']
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
        [:COMMENT_LINE, "#"], [:IDENTIFIER, "this"], [:IDENTIFIER, "method"], [:IDENTIFIER, "does"], [:IDENTIFIER, "something"], [:NEW_LINE, 'n'],
        [:IDENTIFIER, "end"], [:NEW_LINE, 'n']
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
