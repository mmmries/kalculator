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
    def genericType?(possibleType) #possibleType has to either be a collection or a type
      if(possibleType.class <= Kalculator::Collection)
        return possibleType.type <= @type
      end
      if(possibleType.class == Class)
        return possibleType <= @type
      end
      return false
    end

    def ==(othertype) #othertype has to be a collection or a type
      if(othertype.class <= self.class)
          return othertype.type == self.type
      end
      return false
    end

    def <=(otherobject) # otherobject has to be a collection, a type, or some other object
      if(otherobject.class <= Kalculator::Collection)
        return ((self.class<= otherobject.class) and (self.type <= otherobject.type))
      elsif(otherobject.class == Class)
        if(otherobject == Object)
          return true
        end
        return false
      elsif(otherobject.class != Class)
        return false
      end

      return false
    end

    def >=(otherobject) # otherobject has to be a collection, a type, or some other object
      if(otherobject.class <=Kalculator::Collection)
        return otherobject<= self
      elsif(otherobject.class == Class)
        return false
      elsif(otherobject.class != Class)
        return false
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
