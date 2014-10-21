require 'apigen/generation/generator.rb'

class SimpleGenerator < Generator

  def generate(endpoint_group, opts={})
    lines = []
    lines << "Endpoints: #{endpoint_group.size}"
    endpoint_group.endpoints.each do |endpoint|
      lines << endpoint.name
      lines << "#{endpoint.method} #{endpoint.url}"
      lines << ""
    end
    return lines
  end

end
