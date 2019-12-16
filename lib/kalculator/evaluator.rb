#TODO: make it not check each level of ast
require "date"
require "kalculator/types"
require "kalculator/validator"
require "kalculator/type_sources"
class Kalculator
  class Evaluator
    def initialize(data_source, custom_functions = {})

      @data_source = data_source
      @functions = Kalculator::BUILT_IN_FUNCTIONS.merge(custom_functions)
    end

    def evaluate(ast)
      send(ast.first, *ast)
    end



    def access(_, identifier, object, _)

      a = evaluate(object)
      if(a.key?(identifier))
        return a[identifier]
      end
      raise UndefinedVariableError, "object #{a} doesn't have attribute #{identifier}"
    end
    def +(_, left, right, _)
      evaluate(left) + evaluate(right)
    end

    def -(_, left, right,_)
      evaluate(left) - evaluate(right)
    end

    def *(_, left, right,_)
      evaluate(left) * evaluate(right)
    end

    def /(_, left, right,_)
      evaluate(left) / evaluate(right)
    end

    def >(_, left, right,_)
      evaluate(left) > evaluate(right)
    end

    def >=(_, left, right,_)
      evaluate(left) >= evaluate(right)
    end

    def <(_, left, right,_)
      evaluate(left) < evaluate(right)
    end

    def <=(_, left, right,_)
      evaluate(left) <= evaluate(right)
    end

    def ==(_, left, right,_)
      evaluate(left) == evaluate(right)
    end

    def !=(_, left, right,_)
      evaluate(left) != evaluate(right)
    end

    def and(_, left, right,_)
      evaluate(left) && evaluate(right)
    end

    def or(_, left, right,_)
      evaluate(left) || evaluate(right)
    end

    def boolean(_, boolean,_)
      boolean
    end

    def exists(_, variable)
      (_variable, name) = variable
      @data_source.key?(name)
    end

    def fn_call(_, fn_name, expressions,_)
      key = [fn_name, expressions.count]
      fn = @functions[key]
      raise UndefinedFunctionError, "no such function #{fn_name}/#{expressions.count}" if fn.nil?
      args = expressions.map{|expression| evaluate(expression) }
      return fn.call(*args)
    end

    def if(_, condition, true_clause, false_clause,_)
      if evaluate(condition)
        evaluate(true_clause)
      else
        evaluate(false_clause)
      end
    end

    def list(_, expressions,_)
      expressions.map{|expression| evaluate(expression) }
    end

    def not(_, expression,_)
      bool = evaluate(expression)
      !bool
    end

    def null(_, _,_)
      nil
    end

    def number(_, number,_)
      number
    end

    def percent(_, percent,_)
      percent / 100.0
    end

    def string(_, string,_)
      string
    end

    def variable(_, name,_)
      raise UndefinedVariableError, "undefined variable #{name}" unless @data_source.key?(name)
      @data_source[name]
    end
  end
end
