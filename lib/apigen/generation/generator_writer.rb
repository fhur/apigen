class GeneratorWriter

  # A Generator sublcass used to generate the actual code.
  # The output of Generator#generate will be written in 'path'
  attr_accessor :generator

  # the location where this generator should
  # produce output. if path is nil, it should
  # produce output to STDOUT.
  attr_accessor  :path

  # a hash of options
  attr_accessor :opts

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
    return "[ generator: #{@generator.class}, path: #{@path}, opts: #{@opts} ]"
  end
end
