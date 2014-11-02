require 'apigen/generation/generator.rb'
require 'apigen/lang/apigen_compiler.rb'

class Apigen

  def initialize
    @apigen_compiler = ApigenCompiler.new
  end

  # takes a program and a list of generators as input
  # Uses the generator_writers to generate code for the given
  # program and writes the generated code
  # @param {string} program             The actual for for the program.
  # @param {Array of GeneratorWriter}   An Array of generator writers
  def generate(program, generator_writers, opts={})
    endpoint_group = @apigen_compiler.compile program, opts
    Log.d "Using #{generator_writers.size} generators"
    generator_writers.each do |g|
      Log.d "  generating with #{g.class}"
      g.generate_and_write endpoint_group
    end
    Log.d "Generation done."
  end

end
