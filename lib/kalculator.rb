require "rltk"
require "kalculator/data_sources"
require "kalculator/errors"
require "kalculator/evaluator"
require "kalculator/formula"
require "kalculator/lexer"
require "kalculator/parser"
require "kalculator/version"

class Kalculator
  def self.evaluate(formula, data_source = {})
    Kalculator::Formula.new(formula).evaluate(data_source)
  end

  def self.new(*args)
    Kalculator::Formula.new(*args)
  end
end
