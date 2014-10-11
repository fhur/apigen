class GeneratorWriter

  # A Generator sublcass used to generate the actual code.
  # The output of Generator#generate will be written in 'path'
  attr_reader :generator

  # the location where this generator should
  # produce output. if path is nil, it should
  # produce output to stdinput.
  attr_reader :path

  def initialize(generator, path)
    @path = path
    @generator = generator
  end

  # Takes the output of the Generator and writes it to the given path
  # @return the output of the generator
  def generate_and_write(endpoint_group)
    generated = @generator.generate(endpoint_group)
    File.open @generator.path, 'w' do |f|
      f.write generated
    end
    return generated
  end
end
