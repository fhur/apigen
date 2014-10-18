class RequestParam

  # can be one of :field, :part or :body
  attr_accessor :usage
  attr_accessor :name

  def initialize(usage: :body, name: nil)
    @usage, @name = usage, name
  end

  def is_field
    usage == :field
  end

  def is_part
    usage == :part
  end

  def is_body
    usage == :body
  end

end
