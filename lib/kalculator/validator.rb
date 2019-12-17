##
#Author: Benjamin Walter Newhall 12/17/19, github: bennewhall
#Explanation: A class that will either return the ending type of an ast, or throw an error with metadata information about error position
#Usage: v = Validator.new(typesource)       (typesource is a TypeSources object)
#       v.validate(ast)                     (ast is the ast returned by parsing a line)(this will either return a type or throw an Error as described in the errors.rb file)
##
require "kalculator/errors"
require "kalculator/types"
require "kalculator/pointer"
class Kalculator
  class Validator
    def initialize(type_source)
      @type_source = type_source
      #e stores built in function type data
      #last index is ALWAYS the return type, and types before that are types of children from left to right
      e = { "contains" => [Collection.new(Object), Object, Bool],
        "count" => [List.new(Object), Number],
        "date" => [String.new, Date],
        "max"=> [Number,Number,Number],
        "min" => [Number,Number,Number],
        "sum" => [List.new(Number), Number] #this only accepts number Lists
      }
      @environment = e.merge(type_source.toHash)
    end

    def validate(ast)
      send(ast.first, *ast)

    end

    def access(_,identifier,object, metadata)
      objectType = validate(object)
      if((objectType.is_a?(MappedObject)))
        if(objectType.hash.key?(identifier))
          attribute =objectType.hash[identifier]
          if(attribute.is_a?(Pointer))
            attribute = @environment[attribute.p] #if the attribute is a pointer find an add
          end
          return attribute
        end
        raise UndefinedVariableError.new(metadata), "object #{objectType} doesn't have type attribute #{identifier}"
      end
      raise TypeError.new(metadata), "trying to access something that isn't an object"
    end

    def +(_, left, right, metadata)
      leftType = validate(left)
      if((leftType==validate(right)) and leftType <=Number)
        return leftType
      end
    raise TypeError.new(metadata), "not operating on two of the same Number types"
    end

    def -(_, left, right, metadata)
      leftType = validate(left)
      if((leftType==validate(right)) and leftType <=Number)
        return leftType
      end
    raise TypeError.new(metadata), "not operating on two of the same Number types"
    end

    def *(_, left, right, metadata)
      leftType = validate(left)
      if((leftType==validate(right)) and leftType <=Number)
        return leftType
      end
    raise TypeError.new(metadata), "not operating on two of the same Number types"
    end

    def /(_, left, right, metadata)
      leftType = validate(left)
      if((leftType==validate(right)) and leftType <=Number)
        return leftType
      end
    raise TypeError.new(metadata), "not operating on two of the same Number types"
    end

    def >(_, left, right, metadata)
      leftType = validate(left)
      if((leftType==validate(right)) and leftType<= Comparable)
        return Bool
      end
    raise TypeError.new(metadata), "not comparing two of the same comparable types"
    end

    def >=(_, left, right, metadata)
      leftType = validate(left)
      if((leftType==validate(right)) and leftType<= Comparable)
        return Bool
      end
    raise TypeError.new(metadata), "not comparing two of the same comparable types"
    end

    def <(_, left, right, metadata)
      leftType = validate(left)
      if((leftType==validate(right)) and leftType<= Comparable)
        return Bool
      end
    raise TypeError.new(metadata), "not comparing two of the same types"
    end

    def <=(_, left, right, metadata)
      leftType = validate(left)
      if((leftType==validate(right)) and leftType<= Comparable)
        return Bool
      end
    raise TypeError.new(metadata), "not comparing two of the same comparable types"
    end

    def ==(_, left, right, metadata)
      leftType = validate(left)
      if((leftType==validate(right)) and leftType<= Comparable)
        return Bool
      end
    raise TypeError.new(metadata), "not comparing two of the same comparable types"
    end

    def !=(_, left, right, metadata)
      leftType = validate(left)
      if((leftType==validate(right)) and leftType<= Comparable)
        return Bool
      end
    raise TypeError.new(metadata), "not comparing two of the same comparable types"
    end

    def and(_, left, right, metadata)
      if(validate(left)<=Bool and validate(right)<=Bool)
        return Bool
      end
    raise TypeError.new(metadata), "not comparing (AND) two BOOL types"
    end

    def or(_, left, right, metadata)
      if(validate(left)<=Bool and validate(right)<=Bool)
        return Bool
      end
    raise TypeError.new(metadata), "not comparing (OR) two BOOL types"
    end

    def boolean(_, boolean, type, metadata)
      return Bool
    end

    def exists(_, variable, metadata)
        return Bool
    end

    def fn_call(_, fn_name, expressions, metadata) #compare individually to make sure it is a subclass or class
      ex =expressions.map{|expression| validate(expression) }
      raise UndefinedVariableError.new(metadata), "undefined variable #{fn_name}" unless @environment.key?(fn_name)
      if(ex.zip(@environment[fn_name]).all?{|(arg_type, expected_type)| arg_type <= expected_type}) # make sure each element is related to corresponding element in the funcion params
        if(fn_name == "max" or fn_name == "min") #add functions here where output type depends on input type and all types must be exact same ie. max(Percent,Percent) => Percent max(Number,Percent)=> Error max(Number,Number)=>Number
          #check all expressions are same
          cmptype = ex[0]
          if( ex.all?{|t| t == cmptype})
            return cmptype
          end
          raise TypeError.new(metadata), "specialized function type error"
        end
        #add other specialized functions here
        if(fn_name == "contains") #generic function in the format List<E>, E => ReturnType
          if(ex[0].genericType?(ex[1]))
            return @environment[fn_name][@environment[fn_name].size - 1]
          end
          raise TypeError.new(metadata), "generic function type error"
        end
        return @environment[fn_name][@environment[fn_name].size - 1]
      end
      raise TypeError.new(metadata), "function type error"
    end

    def if(_, condition, true_clause, false_clause, metadata)
      conditionType = validate(condition)
      if(conditionType <= Object and validate(true_clause)==validate(false_clause))
        return validate(true_clause)
      end
    raise TypeError.new(metadata), "if statement type error"
    end

    def list(_, expressions, metadata)
      ex =expressions.map{|expression| validate(expression) }

      cmptype = ex[0]
      if( ex.all?{|t| t == cmptype})
        return List.new(cmptype)
      end
    raise TypeError.new(metadata), "list type error"

    end

    def not(_, expression, metadata)
      if(validate(expression) ==Bool)
        return Bool

      end
      raise TypeError.new(metadata), "NOT expression type error"
    end

    def null(_, _, type, metadata)
      return type
    end

    def number(_, number, type, metadata)
      return type
    end

    def percent(_, percent, type, metadata)
      return type
    end

    def string(_, string, type, metadata)
      return type
    end

    def variable(_, name, metadata)

      raise UndefinedVariableError.new(metadata), "undefined variable #{name}" unless @environment.key?(name)
      variableType = @environment[name]
      if(variableType.is_a?(Pointer))
        variableType = @environment[variableType.p] #if the variable you are accessing is a pointer, then return the type of the variable it is pointing to
      end
      return variableType
    end

  end
end
