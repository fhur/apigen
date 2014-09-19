# represents an http ver or method
class Method

  attr_reader :name
  attr_reader :has_body

  def initialize(name: require_name, has_body: false)
    @name, @has_body = name, has_body
  end

  def Method.GET
    Method.new name: :get
  end

  def Method.DELETE
    Method.new name: :delete
  end

  def Method.POST
    Method.new name: :post, has_body: true
  end

  def Method.PUT
    Method.new name: :put, has_body: true
  end

end


