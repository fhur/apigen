# Represents an http header name value pair
class Header

  attr_accessor :name
  attr_accessor :value

  def initialize(name: name_required, value: value_required)
    @name, @value = name, value
  end
end
