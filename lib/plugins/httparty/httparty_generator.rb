require './generator.rb'

class HTTPartyGenerator < Generator

  def initialize(endpoint_group)
    super('./plugins/simple/httparty.mustache', endpoint_group)
  end
end
