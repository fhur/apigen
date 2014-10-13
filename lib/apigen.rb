require './lib/generation/generator.rb'
require './lib/lang/apigen_compiler.rb'

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
    @apigen_compiler.compile program, opts
    generator_writers.each do |g|
      g.generate_and_write endpoint_group
    end
  end

end
