require "rltk"
require "kalculator/data_sources"
require "kalculator/errors"
require "kalculator/evaluator"
require "kalculator/formula"
require "kalculator/lexer"
require "kalculator/nested_lookup"
require "kalculator/parser"
require "kalculator/transform"
require "kalculator/version"

class Kalculator
  def self.evaluate(formula, data_source = {})
    Kalculator::Formula.new(formula).evaluate(data_source)
  end

  def self.new(*args)
    Kalculator::Formula.new(*args)
  end

  def self.parse(formula)
    Kalculator::Parser.parse(Kalculator::Lexer.lex(formula))
  end
end
