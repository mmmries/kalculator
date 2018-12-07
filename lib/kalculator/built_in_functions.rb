class Kalculator
  module BuiltInFunctions
    def self.count(collection)
      raise TypeError, "count only works with Enumerable types, got #{collection.inspect}" unless collection.is_a?(Enumerable)
      collection.count
    end

    def self.contains(collection, item)
      if collection.is_a?(Array)
        collection.include?(item)
      elsif collection.is_a?(String) && item.is_a?(String)
        collection.include?(item)
      else
        raise TypeError, "contains only works with strings or lists, got #{collection.inspect} and #{item.inspect}"
      end
    end

    def self.date(str)
      raise TypeError, "date only works with Strings, got #{str.inspect}" unless str.is_a?(String)
      Date.parse(str)
    end

    def self.sum(array)
      unless array.is_a?(Array) && array.all?{|n| n.is_a?(Numeric)}
        raise TypeError, "sum only works with lists of numbers, got #{array.inspect}"
      end
      array.inject(0){|sum, num| sum + num}
    end
  end
end
