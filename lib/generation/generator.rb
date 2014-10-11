class Generator

  # Generates the actual code given an EndpointGroup as input
  # @return the generated code
  def generate(endpoint_group)
    raise "Unimplemented method => generators must provide their own generation algorithm"
  end
end


