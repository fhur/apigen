require 'json'

class ConfigReader

  # A string indicating the location of the input file
  attr_reader :endpoints

  def initialize(config_json)
    config = JSON.parse(config_json)
    @endpoints = parse_endpoints(config)
  end

  private

  # Parses the json config
  def parse_endpoints(config)
    endpoints = get_key(config,'endpoints').map do |endpoint|
      parse_endpoint(endpoint)
    end
    return endpoints
  end

  # Given a hash with the following structure:
  #
  # {
  #   'input' => [String],
  #   'generators' => [Array]
  # }
  #
  # And 'generators' is an array of elements with the following structure
  #
  # 'require' => [String]
  # 'out' => [String]
  # 'class' => [String]
  # 'opts' => [Hash]
  #
  # Returns the result of parsing the given endpoint hash. The output
  # is a Hash with the following structure
  # {
  #   :input => [String],
  #   :generators => [Array of parsed generators]
  # }
  #
  def parse_endpoint(endpoint_config)
    input = get_key(endpoint_config, 'input')
    generators = get_key(endpoint_config,'generators').map do |g|
      parse_generator(g)
    end
    return {
      :input => input,
      :generators => generators
    }
  end

  # Takes as input a hash with the following keys: 'require',
  # 'out', 'opts' and 'class'
  # @return an instance of GeneratorWriter
  def parse_generator(gen_hash)
    # parse the hash and extract the require name,
    # the output path and the options
    req_name = gen_hash['require']
    out_path = gen_hash['out']
    class_name = gen_hash['class']
    opts = gen_hash['opts']

    # in case the require cannot be completed, throw a meaningful
    # error message
    begin
      require req_name
    rescue LoadError
      raise "Unable to require '#{req_name}' in generator #{gen_hash}"
    end

    # creates a new instance of Generator
    generator = Object::const_get class_name

    # Creates the GeneratorWriter, assigns the generator
    # and the path
    generator_writer = GeneratorWriter.new
    generator_writer.path = out_path
    generator_writer.generator = generator
    generator_writer.opts = opts
    return generator_writer
  end

  def get_key(hash, key)
    if hash.has_key? key
      return hash[key]
    else
      raise "key '#{key}' was expected but not found in #{hash}"
    end
  end

  def inspect
    @endpoints.inspect
  end
end
