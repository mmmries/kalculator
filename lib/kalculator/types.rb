class Kalculator
  class Comparable; end
  class Number< Comparable; end
  class Percent < Number; end
  class Bool; end
  class Date; end
  class Collection
    attr_reader :type
    def initialize(type)
      @type = type
    end
    def genericType?(possibleType)
      return possibleType <= @type
    end

    def ==(othertype)
      if(othertype.is_a?(self.class))
          return othertype.type == self.type
      end
      return false
    end

    def <=(othertype)
      if(othertype.class == Class)
        return self.class <= othertype
      end
      if(self.class<= othertype.class)
          return self.type == othertype.type
      end
      return false
    end
  end

  class String < Collection
    def initialize()
      super(String)
    end
  end

  class List < Collection
    def initialize(type)
      super(type)
    end
  end

end
