class QueryParam

  attr_accessor :name
  attr_accessor :type

  def initialize(name: force_name, type: :string)
    @name, @type = name, type
  end
end


