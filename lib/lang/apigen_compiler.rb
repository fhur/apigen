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
  # @param {string} opts  A hash containing a list of options passed to the EndpointGroup
  #                       This hash can contain additional information needed for generators
  #                       like a name, description, creation_date, etc.
  def compile(code, opts={})
    comment_blocks = @comment_parser.parse_and_join code
    endpoints = comment_blocks.map do |comment_block|
      begin
        @endpoint_compiler.compile comment_block
      rescue Racc::ParseError
        nil
      end
    end
    endpoints = endpoints.select { |endpoint| not endpoint.nil? }
    return EndpointGroup.new opts: opts, endpoints: endpoints
  end
end
