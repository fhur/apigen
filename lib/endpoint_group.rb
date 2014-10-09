class EndpointGroup

  attr_reader :name
  attr_reader :endpoints

  # Creates a new EndpointGroup with an empty endpoint list
  # @param {string} name  Can be nil, specifies the name for the EndpointGroup. This value
  #                       is used by generators to produce class names for example.
  def initialize(name: nil, endpoints: [])
    @name = name
    @endpoints = endpoints
  end

  # adds a new endpoint to the endpoint group
  def add(endpoint)
    @endpoints.push endpoint
  end

  # returns the number of enpoints in this EndpointGroup
  def size
    @endpoints.size
  end

end
