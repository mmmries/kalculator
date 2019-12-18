require "rltk"
require "kalculator/built_in_functions"
require "kalculator/data_sources"
require "kalculator/errors"
require "kalculator/evaluator"
require "kalculator/formula"
require "kalculator/lexer"
require "kalculator/parser"
require "kalculator/transform"
require "kalculator/version"
require "kalculator/validator"
require "kalculator/type_sources"




class Kalculator
  def self.evaluate(formula, data_source = {}, custom_functions = {})
    Kalculator::Formula.new(formula).evaluate(data_source, custom_functions)
  end
  def self.validate(formula,  type_source = Kalculator::TypeSources.new(Hash.new) )
    Kalculator::Formula.new(formula).validate(type_source)
  end
  def self.new(*args)
    Kalculator::Formula.new(*args)
  end

  def self.parse(formula)
    Kalculator::Parser.parse(Kalculator::Lexer.lex(formula))
  end
end
