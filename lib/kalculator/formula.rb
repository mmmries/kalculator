
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

    def evaluate(data_source = {}, custom_functions = {}, type_source = Kalculator::TypeSources.new(Hash.new))
      begin
        Kalculator::Validator.new(type_source).validate(ast)
        Kalculator::Evaluator.new(data_source, custom_functions).evaluate(ast)
      rescue Error => detail
        @string[0...detail.metadata[:offset].min] + @string[detail.metadata[:offset]].colorize(:red) + @string[(detail.metadata[:offset].max+1) ... @string.length] 

      end
    end
  end
end
