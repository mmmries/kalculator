
require "date"
require "kalculator/types"
require "kalculator/validator"
require "kalculator/type_sources"
require "kalculator/pointer"
class Kalculator
  class Evaluator
    def initialize(data_source, custom_functions = {})

      @data_source = data_source
      @functions = Kalculator::BUILT_IN_FUNCTIONS.merge(custom_functions)
    end

    def evaluate(ast)

      send(ast.first, *ast)
    end

    def access(_, identifier, object, metadata)
      a = evaluate(object)
      if(a.key?(identifier))
        b =a[identifier]
        if(b.is_a?(Kalculator::Pointer))
          b = @data_source[b.p]
        end
        return b
      end
      raise UndefinedVariableError.new(metadata), "object #{a} doesn't have attribute #{identifier}"
    end
    def +(_, left, right, metadata)
      evaluate(left) + evaluate(right)
    end

    def -(_, left, right, metadata)
      evaluate(left) - evaluate(right)
    end

    def *(_, left, right, metadata)
      evaluate(left) * evaluate(right)
    end

    def /(_, left, right, metadata)
      evaluate(left) / evaluate(right)
    end

    def >(_, left, right, metadata)
      evaluate(left) > evaluate(right)
    end

    def >=(_, left, right, metadata)
      evaluate(left) >= evaluate(right)
    end

    def <(_, left, right, metadata)
      evaluate(left) < evaluate(right)
    end

    def <=(_, left, right, metadata)
      evaluate(left) <= evaluate(right)
    end

    def ==(_, left, right, metadata)
      evaluate(left) == evaluate(right)
    end

    def !=(_, left, right, metadata)
      evaluate(left) != evaluate(right)
    end

    def and(_, left, right, metadata)
      evaluate(left) && evaluate(right)
    end

    def or(_, left, right, metadata)
      evaluate(left) || evaluate(right)
    end

    def boolean(_, boolean,_, metadata)
      boolean
    end

    def exists(_, variable, metadata)
      @data_source.key?(variable)
    end

    def fn_call(_, fn_name, expressions, metadata)
      key = [fn_name, expressions.count]
      fn = @functions[key]
      raise UndefinedFunctionError.new(metadata), "no such function #{fn_name}/#{expressions.count}" if fn.nil?
      args = expressions.map{|expression| evaluate(expression) }
      return fn.call(*args)
    end

    def if(_, condition, true_clause, false_clause, metadata)
      if evaluate(condition)
        evaluate(true_clause)
      else
        evaluate(false_clause)
      end
    end

    def list(_, expressions, metadata)
      expressions.map{|expression| evaluate(expression) }
    end

    def not(_, expression, metadata)
      bool = evaluate(expression)
      !bool
    end

    def null(_, _,_, metadata)
      nil
    end

    def number(_, number,_, metadata)
      number
    end

    def percent(_, percent,_, metadata)
      percent / 100.0
    end

    def string(_, string,_, metadata)
      string
    end

    def variable(_, name, metadata)
      raise UndefinedVariableError.new(metadata), "undefined variable #{name}" unless @data_source.key?(name)
      a = @data_source[name]
      if(a.is_a?(Pointer))
        a = @data_source[a.p]
      end
      return a
    end
  end
end
