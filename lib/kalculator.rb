require "rltk"
require "kalculator/built_in_functions"
require "kalculator/data_sources"
require "kalculator/errors"
require "kalculator/evaluator"
require "kalculator/formula"
require "kalculator/lexer"
require "kalculator/nested_lookup"
require "kalculator/parser"
require "kalculator/transform"
require "kalculator/version"
require "kalculator/validator"
require "kalculator/type_sources"
require "kalculator/types"
require "kalculator/pointer"
require "colorize"

class Kalculator
  def self.evaluate(formula, data_source = {}, custom_functions = {}, type_source = Kalculator::TypeSources.new(Hash.new))
    Kalculator::Formula.new(formula).evaluate(data_source, custom_functions, type_source)
  end

  def self.new(*args)
    Kalculator::Formula.new(*args)
  end

  def self.parse(formula)
    Kalculator::Parser.parse(Kalculator::Lexer.lex(formula))
  end
end

##A little REPL for testing Kalculator, run kalculator.rb to get this Author: Benjamin Walter Newhall 12/17/19 github: bennewhall
loop do

  print "\nKalc=>  "
  line =gets.chomp
  if(line == "q")
    break
  end

  object = {"bob" => {"name" => "bob", "email" => "bob@spiff.com", "mother" => { "name" => "susan", "child"=> Kalculator::Pointer.new("bob")}}}
  objectType =  {"bob" => Kalculator::MappedObject.new({"name" => Kalculator::String.new, "email" => Kalculator::String.new, "mother" => Kalculator::MappedObject.new({ "name" => Kalculator::String.new, "child"=> Kalculator::Pointer.new("bob")})})}
  pointerVar = {"person"=> Kalculator::Pointer.new("bob")}
  pointerVarType = {"person" => Kalculator::Pointer.new("bob")}

  t = Kalculator::TypeSources.new({"paycheck"=> Kalculator::Number,"daysOff"=>Kalculator::Number, "payroll"=> Kalculator::List.new(Kalculator::Number), "grade" => Kalculator::Percent}, {"alive"=>Kalculator::Bool, "nothing"=>Object, "name"=>Kalculator::String.new}, objectType, pointerVarType)
  d = Kalculator::DataSources.new({"paycheck"=> 100, "daysOff"=>8, "payroll"=> [8,5,100,59], "grade" => 50}, {"alive"=>false, "nothing"=>nil, "name"=>"bobby"}, object, pointerVar)

  calc = Kalculator.new(line)

  puts( calc.evaluate(d, {},t))


end
