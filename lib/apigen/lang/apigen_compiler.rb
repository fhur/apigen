require 'apigen/log.rb'
require 'apigen/lang/comment_parser.rb'
require 'apigen/lang/endpoint_compiler.rb'
require 'apigen/endpoint_group.rb'

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
    Log.d "Parsing comment blocks"
    comment_blocks = @comment_parser.parse_and_join code
    Log.d "#{comment_blocks.size} comment blocks detected"
    endpoints = comment_blocks.map do |comment_block|
      begin
        Log.d "Parsing '#{comment_block[0..10]}...'"
        compiled = @endpoint_compiler.compile comment_block
        Log.d "Success"
        compiled
      rescue Racc::ParseError => e
        Log.d "  Unable to process comment_block:"
        Log.d "  '#{comment_block}'"
        Log.d "  Cause: #{e.message.gsub("\n","")} "
        nil
      end
    end
    endpoints = endpoints.select { |endpoint| not endpoint.nil? }
    Log.d "#{endpoints.size} endpoints parsed : #{endpoints.map {|e| e.name}.join(',')}"
    return EndpointGroup.new opts: opts, endpoints: endpoints
  end
end
