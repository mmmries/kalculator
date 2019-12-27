##
#Author: Benjamin Walter Newhall 12/17/19 github: bennewhall
#Explanation: A class that holds the types used for the validator
##


class Kalculator
  class Comparable; end #A Type that can be used in <, >, etc. operations
  class Number< Comparable; end #A Type that can be used in +,-,etc operations
  class Percent < Number; end #a type of number
  class Bool; end
  class Time; end

  #a generic collection type of type Collection<othertype> where othertype is stored in the type instance variable
  class Collection
    attr_reader :type
    def initialize(type)
      @type = type
    end
    def generic_type?(possible_type) #possibleType has to either be a collection or a type
      if(possible_type.class <= Kalculator::Collection)
        return possible_type.type <= @type
      end
      if(possible_type.class == Class)
        return possible_type <= @type
      end
      return false
    end

    def ==(other_type) #othertype has to be a collection or a type
      if(other_type.class <= self.class)
          return other_type.type == self.type
      end
      return false
    end

    def <=(other_object) # otherobject has to be a collection, a type, or some other object
      if(other_object.class <= Kalculator::Collection)
        return ((self.class<= other_object.class) and (self.type <= other_object.type))
      elsif(other_object.class == Class)
        if(other_object == Object)
          return true
        end
        return false
      elsif(other_object.class != Class)
        return false
      end

      return false
    end

    def >=(other_object) # otherobject has to be a collection, a type, or some other object
      if(other_object.class <=Kalculator::Collection)
        return other_object<= self
      elsif(other_object.class == Class)
        return false
      elsif(other_object.class != Class)
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
