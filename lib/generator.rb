require 'mustache'

class Generator

  attr_reader :template
  attr_reader :endpoint_group

  def initialize(template, endpoint_group)
    @template = template
    @endpoint_group = endpoint_group
  end

  # @deprecated generators should be able to specify their own ways of generating
  # code, not restricted to mustaches. Also, mustache is probably not even a good
  # idea for code generation.
  def generate
    Mustache.render(@template, @endpoint_group)
  end

end
