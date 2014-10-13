class GeneratorWriter

  # A Generator sublcass used to generate the actual code.
  # The output of Generator#generate will be written in 'path'
  attr_writer :generator

  # the location where this generator should
  # produce output. if path is nil, it should
  # produce output to stdinput.
  attr_writer :path

  # a hash of options
  attr_writer :opts

  # Takes the output of the Generator and writes it to the given path
  # @return the output of the generator
  def generate_and_write(endpoint_group)
    generated = @generator.generate(endpoint_group, @opts)
    File.open @path, 'w' do |f|
      f.write generated
    end
    return generated
  end

  def inspect
    "generator: #{generator.class}, path: #{path}, opts: #{opts}"
  end
end
