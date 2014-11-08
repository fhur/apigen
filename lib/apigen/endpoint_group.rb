class EndpointGroup

  attr_reader :opts
  attr_reader :endpoints

  # Creates a new EndpointGroup with an empty endpoint list
  # @param {string} opts   A hash containing optional data for this group.
  def initialize(opts: {}, endpoints: [])
    @opts = opts
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

  # Expose private method #binding
  def get_binding
    binding()
  end

end
