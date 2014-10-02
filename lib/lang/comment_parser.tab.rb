#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.12
# from Racc grammer file "".
#

require 'racc/parser.rb'


  require "./lib/lang/comment_lexer.rb"

class CommentParser < Racc::Parser

module_eval(<<'...end comment_parser.y/module_eval...', 'comment_parser.y', 38)

  def parse(code, show_tokens=false)
    @tokens = CommentLexer.new.tokenize(code) # Tokenize the code using our lexer
    puts @tokens.inspect if show_tokens
    do_parse # Kickoff the parsing process
  end

  def next_token
    @tokens.shift
  end
...end comment_parser.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
     5,     4,    10,     8,     6,     9,     5,     4,    14,    15,
    12,    13,    11 ]

racc_action_check = [
     2,     2,     4,     2,     1,     2,     0,     0,    11,    11,
     6,    10,     5 ]

racc_action_pointer = [
     4,     4,    -2,   nil,    -4,     6,    10,   nil,   nil,   nil,
     7,     1,   nil,   nil,   nil,   nil ]

racc_action_default = [
    -1,   -10,    -2,    -4,   -10,   -10,   -10,    -3,    -5,    -6,
   -10,   -10,    16,    -7,    -8,    -9 ]

racc_goto_table = [
     3,     2,     7,     1 ]

racc_goto_check = [
     3,     2,     3,     1 ]

racc_goto_pointer = [
   nil,     3,     1,     0 ]

racc_goto_default = [
   nil,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 10, :_reduce_1,
  1, 10, :_reduce_2,
  2, 11, :_reduce_3,
  1, 11, :_reduce_4,
  2, 11, :_reduce_5,
  2, 11, :_reduce_6,
  3, 12, :_reduce_7,
  3, 12, :_reduce_8,
  3, 12, :_reduce_9 ]

racc_reduce_n = 10

racc_shift_n = 16

racc_token_table = {
  false => 0,
  :error => 1,
  :COMMENT_LINE => 2,
  :COMMENT_START => 3,
  :COMMENT_END => 4,
  :IDENTIFIER => 5,
  :COMMENT => 6,
  :NEW_LINE => 7,
  :EOF => 8 }

racc_nt_base = 9

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "COMMENT_LINE",
  "COMMENT_START",
  "COMMENT_END",
  "IDENTIFIER",
  "COMMENT",
  "NEW_LINE",
  "EOF",
  "$start",
  "program",
  "expressions",
  "comment" ]

Racc_debug_parser = true

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'comment_parser.y', 16)
  def _reduce_1(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'comment_parser.y', 17)
  def _reduce_2(val, _values, result)
     result = val 
    result
  end
.,.,

module_eval(<<'.,.,', 'comment_parser.y', 20)
  def _reduce_3(val, _values, result)
     result = val[0] << val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'comment_parser.y', 21)
  def _reduce_4(val, _values, result)
     result = val 
    result
  end
.,.,

module_eval(<<'.,.,', 'comment_parser.y', 22)
  def _reduce_5(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'comment_parser.y', 23)
  def _reduce_6(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'comment_parser.y', 26)
  def _reduce_7(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'comment_parser.y', 27)
  def _reduce_8(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'comment_parser.y', 28)
  def _reduce_9(val, _values, result)
     result = val[1] 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class CommentParser
