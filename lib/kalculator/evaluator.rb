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

    def contains(_, collection, item)
      collection = evaluate(collection)
      item = evaluate(item)
      if collection.is_a?(Array)
        collection.include?(item)
      elsif collection.is_a?(String) && item.is_a?(String)
        collection.include?(item)
      else
        raise TypeError, "contains only works with strings or lists, got #{collection.inspect} and #{item.inspect}"
      end
    end

    def count(_, collection)
      collection = evaluate(collection)
      raise TypeError, "count only works with Enumerable types, got #{collection.inspect}" unless collection.is_a?(Enumerable)
      collection.count
    end

    def date(_, expression)
      value = evaluate(expression)
      raise TypeError, "date only works with Strings, got #{value.inspect}" unless value.is_a?(String)
      Date.parse(value)
    end

    def exists(_, variable_name)
      @data_source.key?(variable_name)
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
