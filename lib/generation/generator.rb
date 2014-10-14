class Generator

  # Generates the actual code given an EndpointGroup as input
  # @param {EndpointGroup}  endpoint_group  the metamodel used for code generation
  # @param {Hahs}           opts            a hash containing options passed to the generation.
  #                                         opts is an empty hash by default.
  # @return the generated code
  def generate(endpoint_group, opts={})
    raise NotImplementedError, "generators must provide their own generation algorithm"
  end
end


