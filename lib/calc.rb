require "rltk"
require "calc/data_sources"
require "calc/evaluator"
require "calc/lexer"
require "calc/parser"

class Calc
  def self.evaluate(formula, data_source = {})
    new(formula).evaluate(data_source)
  end

  attr_reader :ast, :string

  def initialize(string)
    @ast = Calc::Parser.parse(Calc::Lexer.lex(string))
    @string = string
  end

  def evaluate(data_source = {})
    Calc::Evaluator.new(data_source).evaluate(ast)
  end
end
