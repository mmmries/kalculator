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

    def boolean(_, boolean)
      boolean
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
      evaluate(array).inject(0){|sum, num| sum + num}
    end

    def variable(_, names)
      names.inject(@data_source) do |source, name|
        raise "undefined variable #{names.join(".")} (could not find #{name} in #{source}" unless source.key?(name)
        source[name]
      end
    end
  end
end
