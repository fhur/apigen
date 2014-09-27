# represents an http ver or method
class HttpMethod

  attr_reader :name
  attr_reader :has_body

  def initialize(name: require_name, has_body: false)
    @name, @has_body = name, has_body
  end

  def HttpMethod.get
    HttpMethod.new name: :get
  end

  def HttpMethod.delete
    HttpMethod.new name: :delete
  end

  def HttpMethod.post
    HttpMethod.new name: :post, has_body: true
  end

  def HttpMethod.put
    HttpMethod.new name: :put, has_body: true
  end

  def HttpMethod.create(method_name)
    HttpMethod.send(method_name)
  end

  def ==(other)
    self.name == other.name and self.has_body == other.has_body
  end

end


