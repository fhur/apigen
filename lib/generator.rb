require 'mustache'

class Generator

  attr_reader :template
  attr_reader :endpoint_group

  def initialize(template, endpoint_group)
    @template = template
    @endpoint_group = endpoint_group
  end

  def generate
    Mustache.render(@template, @endpoint_group)
  end

end
