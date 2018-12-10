class Kalculator
  BUILT_IN_FUNCTIONS = {
    ["contains", 2] => lambda { |collection, item|
      if collection.is_a?(Array)
        collection.include?(item)
      elsif collection.is_a?(String) && item.is_a?(String)
        collection.include?(item)
      else
        raise TypeError, "contains only works with strings or lists, got #{collection.inspect} and #{item.inspect}"
      end
    },
    ["count", 1] => lambda { |list|
      raise TypeError, "count only works with Enumerable types, got #{list.inspect}" unless list.is_a?(Enumerable)
      list.count
    },
    ["date", 1] => lambda { |str|
      raise TypeError, "date only works with Strings, got #{str.inspect}" unless str.is_a?(String)
      Date.parse(str)
    },
    ["max", 2] => lambda { |left, right|
      raise TypeError, "max only works with numbers, got #{left.inspect}" unless left.is_a?(Numeric)
      raise TypeError, "max only works with numbers, got #{right.inspect}" unless right.is_a?(Numeric)
      [left, right].max
    },
    ["min", 2] => lambda { |left, right|
      raise TypeError, "min only works with numbers, got #{left.inspect}" unless left.is_a?(Numeric)
      raise TypeError, "min only works with numbers, got #{right.inspect}" unless right.is_a?(Numeric)
      [left, right].min
    },
    ["sum", 1] => lambda { |list|
      unless list.is_a?(Array) && list.all?{|n| n.is_a?(Numeric)}
        raise TypeError, "sum only works with lists of numbers, got #{list.inspect}"
      end
      list.inject(0){|sum, num| sum + num}
    },
  }.freeze
end
