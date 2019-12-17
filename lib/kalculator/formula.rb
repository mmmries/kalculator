
require "kalculator/types"
require "kalculator/validator"
require "kalculator/type_sources"
require "colorize"
class Kalculator
  class Formula
    attr_reader :ast, :string

    def initialize(string)
      @ast = Kalculator::Parser.parse(Kalculator::Lexer.lex(string))
      @string = string
    end

    def validate( type_source = Kalculator::TypeSources.new(Hash.new))
      Kalculator::Validator.new(type_source).validate(ast)
    end

    def evaluate(data_source = {}, custom_functions = {})
      Kalculator::Evaluator.new(data_source, custom_functions).evaluate(ast)
    end
    
  end
end
