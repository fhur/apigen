#require './lib/generator.rb'
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apigen'
class HTTPartyGenerator < Generator

  def initialize(endpoint_group)
    super(File.read('./lib/plugins/httparty/httparty.mustache'), endpoint_group)
  end
end
