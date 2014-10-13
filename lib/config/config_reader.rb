require 'json'

class ConfigReader

  # A string indicating the location of the input file
  attr_reader :input

  # An array of GeneratorWriter
  attr_reader :generators

  def initialize(config_json)
    config = JSON.parse(config_json)
    parse_config(config)
  end

  private

  def parse_config(config)
    @input = config['input']
    @generators = config['generators'].map do |g|
      parse_generator(g)
    end
  end

  # Takes as input a hash with the following keys: 'require',
  # 'out', 'opts'.
  # @return an instance of GeneratorWriter
  def parse_generator(gen_hash)
    # parse the hash and extract the require name,
    # the output path and the options
    req_name = gen_hash['require']
    out_path = gen_hash['out']
    opts = gen_hash['opts']

    # in case the require cannot be completed, throw a meaningful
    # error message
    begin
      require req_name
    rescue LoadError
      raise "Unable to require '#{req_name}' in generator #{gen_hash}"
    end

    # creates a new instance of Generator
    generator = Object::const_get req_name

    # Creates the GeneratorWriter, assigns the generator
    # and the path
    generator_writer = GeneratorWriter.new
    generator_writer.path = out_path
    generator_writer.generator = generator
    generator_writer.opts = opts
    return generator_writer
  end

  def inspect
    "input: #{@input}, generators: #{@generators}"
  end
end
