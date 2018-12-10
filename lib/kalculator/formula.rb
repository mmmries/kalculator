class Kalculator
  class Formula
    attr_reader :ast, :string

    def initialize(string)
      @ast = Kalculator::Parser.parse(Kalculator::Lexer.lex(string))
      @string = string
    end

    def evaluate(data_source = {}, custom_functions = {})
      Kalculator::Evaluator.new(data_source, custom_functions).evaluate(ast)
    end
  end
end
