require './lib/lang/comment_parser.rb'
require './lib/lang/endpoint_compiler.rb'
require './lib/endpoint_group.rb'

class ApigenCompiler

  def initialize
    @comment_parser = CommentParser.new
    @endpoint_compiler = EndpointCompiler.new
  end

  def compile(code, name)
    comment_blocks = @comment_parser.parse_and_join code
    endpoints = comment_blocks.map do |comment_block|
      @endpoint_compiler.compile comment_block
    end
    return EndpointGroup.new name: name, endpoints: endpoints
  end
end
