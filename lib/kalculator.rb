require "rltk"
require "kalculator/data_sources"
require "kalculator/errors"
require "kalculator/evaluator"
require "kalculator/lexer"
require "kalculator/parser"
require "kalculator/version"

class Kalculator
  def self.evaluate(formula, data_source = {})
    new(formula).evaluate(data_source)
  end

  attr_reader :ast, :string

  def initialize(string)
    @ast = Kalculator::Parser.parse(Kalculator::Lexer.lex(string))
    @string = string
  end

  def evaluate(data_source = {})
    Kalculator::Evaluator.new(data_source).evaluate(ast)
  end
end
