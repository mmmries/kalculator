class Kalculator
  BUILT_IN_FUNCTIONS = {
    ["contains", 2] => lambda { |collection, item|
        collection.include?(item)
    },
    ["count", 1] => lambda { |list|
      list.count
    },
    ["date", 1] => lambda { |str|
      Date.parse(str)
    },
    ["max", 2] => lambda { |left, right|
      [left, right].max
    },
    ["min", 2] => lambda { |left, right|
      [left, right].min
    },
    ["sum", 1] => lambda { |list|
      list.inject(0){|sum, num| sum + num}
    },
  }.freeze
end
