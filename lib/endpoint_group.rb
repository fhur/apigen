class EndpointGroup

  attr_reader :name
  attr_reader :endpoints

  def initialize(name: nil, endpoints: [])
    @name = name
    @endpoints = endpoints
  end

  def add(endpoint)
    @endpoints.push endpoint
  end

end
