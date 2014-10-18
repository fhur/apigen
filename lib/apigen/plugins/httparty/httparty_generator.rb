require './lib/generator.rb'

class HTTPartyGenerator < Generator

  def initialize(endpoint_group)
    super(File.read('./lib/plugins/httparty/httparty.mustache'), endpoint_group)
  end
end
