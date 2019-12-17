##
#Author: Benjamin Walter Newhall 12/17/19 github: bennewhall
#Explanation: A class that holds the types used for the validator
##


class Kalculator
  class Comparable; end #A Type that can be used in <, >, etc. operations
  class Number< Comparable; end #A Type that can be used in +,-,etc operations
  class Percent < Number; end #a type of number
  class Bool; end
  class Date; end

  #a generic collection type of type Collection<othertype> where othertype is stored in the type instance variable
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


  class String < Collection #a collection that holds strings
    def initialize()
      super(String)
    end
  end

  class List < Collection #a collection that holds one type of data
    def initialize(type)
      super(type)
    end
  end

  class MappedObject < Collection #a collection that represents an object and holds any type of data
    attr_reader :hash
    def initialize(hash)
      super(Object)
      @hash = hash
    end
  end
end
