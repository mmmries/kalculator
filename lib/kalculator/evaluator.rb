require "date"

class Kalculator
  class Evaluator
    def initialize(data_source)
      @data_source = data_source
    end

    def evaluate(ast)
      send(ast.first, *ast)
    end

    def +(_, left, right)
      evaluate(left) + evaluate(right)
    end

    def -(_, left, right)
      evaluate(left) - evaluate(right)
    end

    def *(_, left, right)
      evaluate(left) * evaluate(right)
    end

    def /(_, left, right)
      evaluate(left) / evaluate(right)
    end

    def >(_, left, right)
      evaluate(left) > evaluate(right)
    end

    def >=(_, left, right)
      evaluate(left) >= evaluate(right)
    end

    def <(_, left, right)
      evaluate(left) < evaluate(right)
    end

    def <=(_, left, right)
      evaluate(left) <= evaluate(right)
    end

    def ==(_, left, right)
      evaluate(left) == evaluate(right)
    end

    def !=(_, left, right)
      evaluate(left) != evaluate(right)
    end

    def and(_, left, right)
      evaluate(left) && evaluate(right)
    end

    def or(_, left, right)
      evaluate(left) || evaluate(right)
    end

    def boolean(_, boolean)
      boolean
    end

    def exists(_, variable)
      (_variable, name) = variable
      @data_source.key?(name)
    end

    def fn_call(_, fn_name, expressions)
      key = [fn_name, expressions.count]
      fn = Kalculator::BUILT_IN_FUNCTIONS[key]
      raise UndefinedFunctionError, "no such function #{fn_name}/#{expressions.count}" if fn.nil?
      args = expressions.map{|expression| evaluate(expression) }
      return fn.call(*args)
    end

    def if(_, condition, true_clause, false_clause)
      if evaluate(condition)
        evaluate(true_clause)
      else
        evaluate(false_clause)
      end
    end

    def list(_, expressions)
      expressions.map{|expression| evaluate(expression) }
    end

    def max(_, left, right)
      left = evaluate(left)
      right = evaluate(right)
      raise TypeError, "max only works with numbers, got #{left.inspect}" unless left.is_a?(Numeric)
      raise TypeError, "max only works with numbers, got #{right.inspect}" unless right.is_a?(Numeric)
      [left, right].max
    end

    def min(_, left, right)
      left = evaluate(left)
      right = evaluate(right)
      raise TypeError, "min only works with numbers, got #{left.inspect}" unless left.is_a?(Numeric)
      raise TypeError, "min only works with numbers, got #{right.inspect}" unless right.is_a?(Numeric)
      [left, right].min
    end

    def not(_, expression)
      bool = evaluate(expression)
      raise TypeError, "! only works with booleans, got #{bool.inspect}" unless bool === true || bool === false
      !bool
    end

    def null(_, _)
      nil
    end

    def number(_, number)
      number
    end

    def percent(_, percent)
      percent / 100.0
    end

    def string(_, string)
      string
    end

    def variable(_, name)
      raise UndefinedVariableError, "undefined variable #{name}" unless @data_source.key?(name)
      @data_source[name]
    end
  end
end
