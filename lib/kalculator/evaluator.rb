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

    def and(_, left, right)
      evaluate(left) && evaluate(right)
    end

    def or(_, left, right)
      evaluate(left) || evaluate(right)
    end

    def boolean(_, boolean)
      boolean
    end

    def contains(_, string, substring)
      string = evaluate(string)
      substring = evaluate(substring)
      unless string.is_a?(String) && substring.is_a?(String)
        raise TypeError, "contains only works with strings, got #{string.inspect} and #{substring.inspect}"
      end
      string.include?(substring)
    end

    def if(_, condition, true_clause, false_clause)
      if evaluate(condition)
        evaluate(true_clause)
      else
        evaluate(false_clause)
      end
    end

    def number(_, number)
      number
    end

    def string(_, string)
      string
    end

    def sum(_, array)
      array = evaluate(array)
      unless array.is_a?(Array) && array.all?{|n| n.is_a?(Numeric)}
        raise TypeError, "sum only works with lists of numbers, got #{array.inspect}"
      end
      array.inject(0){|sum, num| sum + num}
    end

    def variable(_, name)
      raise UndefinedVariableError, "undefined variable #{name}" unless @data_source.key?(name)
      @data_source[name]
    end
  end
end
