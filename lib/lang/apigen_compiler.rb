require './lib/lang/comment_parser.rb'
require './lib/lang/endpoint_compiler.rb'
require './lib/endpoint_group.rb'

class ApigenCompiler

  def initialize
    @comment_parser = CommentParser.new
    @endpoint_compiler = EndpointCompiler.new
  end

  # Compiles a code string into an EndpointGroup
  # @param {string} code  A listeral code string representing the program from which
  #                       comment block will be extracted into endpoints.
  # @param {string} name  A name for the endpoint group. This attribute can be used
  #                       by the generator (i.e. as the class name)
  def compile(code, name)
    comment_blocks = @comment_parser.parse_and_join code
    endpoints = comment_blocks.map do |comment_block|
      begin
        @endpoint_compiler.compile comment_block
      rescue Racc::ParseError
        nil
      end
    end
    endpoints = endpoints.select { |endpoint| not endpoint.nil? }
    return EndpointGroup.new name: name, endpoints: endpoints
  end
end
