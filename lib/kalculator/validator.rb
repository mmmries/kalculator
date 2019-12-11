#TODO: fix error handling to use merge, also ask mike how he wants errors to be handled
require "kalculator/errors"
require "kalculator/types"
class Kalculator
  class Validator
    def initialize(type_source)


      @type_source = type_source
      #e stores built in function type data
      #last index is ALWAYS the return type, and types before that are types of children from left to right
      e = { "contains" => [Collection, Object, Bool],
        "count" => [List, Number],
        "date" => [String, Date],
        "max"=> [Number,Number,Number],
        "min" => [Number,Number,Number],
        "sum" => [NumberList, Number] #this only accepts number Lists
      }
      @environment = e.merge(type_source.toHash)
    end

    def validate(ast)
      send(ast.first, *ast)
    end

    def +(_, left, right, type)
      a = validate(left)
      if((a==validate(right)) and a <=Number)
        return a
      end
    raise TypeError, "not operating on two of the same Number types"
    end

    def -(_, left, right, type)
      a = validate(left)
      if((a==validate(right)) and a <=Number)
        return a
      end
    raise TypeError, "not operating on two of the same Number types"
    end

    def *(_, left, right, type)
      a = validate(left)
      if((a==validate(right)) and a <=Number)
        return a
      end
    raise TypeError, "not operating on two of the same Number types"
    end

    def /(_, left, right, type)
      a = validate(left)
      if((a==validate(right)) and a <=Number)
        return a
      end
    raise TypeError, "not operating on two of the same Number types"
    end

    def >(_, left, right, type)
      a = validate(left)
      if((a==validate(right)) and a<= Comparable)
        return Bool
      end
    raise TypeError, "not comparing two of the same comparable types"
    end

    def >=(_, left, right, type)
      a = validate(left)
      if((a==validate(right)) and a<= Comparable)
        return Bool
      end
    raise TypeError, "not comparing two of the same comparable types"
    end

    def <(_, left, right, type)
      a = validate(left)
      if((a==validate(right)) and a<= Comparable)
        return Bool
      end
    raise TypeError, "not comparing two of the same comparable types"
    end

    def <=(_, left, right, type)
      a = validate(left)
      if((a==validate(right)) and a<= Comparable)
        return Bool
      end
    raise TypeError, "not comparing two of the same comparable types"
    end

    def ==(_, left, right, type)
      a = validate(left)
      if((a==validate(right)) and a<= Comparable)
        return Bool
      end
    raise TypeError, "not comparing two of the same comparable types"
    end

    def !=(_, left, right, type)
      a = validate(left)
      if((a==validate(right)) and a<= Comparable)
        return Bool
      end
    raise TypeError, "not comparing two of the same comparable types"
    end

    def and(_, left, right, type)
      if(validate(left)<=Bool and validate(right)<=Bool)
        return Bool
      end
    raise TypeError, "not comparing (AND) two BOOL types"
    end

    def or(_, left, right, type)
      if(validate(left)<=Bool and validate(right)<=Bool)
        return Bool
      end
    raise TypeError, "not comparing (OR) two BOOL types"
    end

    def boolean(_, boolean, type)
      return Bool
    end

    def exists(_, variable, type)
      if(validate(variable)==String)
        return Bool
      end
      raise TypeError, "exists function type error"
    end

    def fn_call(_, fn_name, expressions, type) #compare individually to make sure it is a subclass or class
      ex =expressions.map{|expression| validate(expression) }
      raise UndefinedVariableError, "undefined variable #{fn_name}" unless @environment.key?(fn_name)
      if(ex.zip(@environment[fn_name]).all?{|a| a[0]<=a[1]}) # make sure each element is related to corresponding element in the funcion params
        if(fn_name == "max" or fn_name == "min") #add functions here where output type depends on input type and all types must be exact same ie. max(Percent,Percent) => Percent max(Number,Percent)=> Error max(Number,Number)=>Number
          #check all expressions are same
          cmptype = ex[0]
          if( ex.all?{|t| t == cmptype})
            return cmptype
          end
          raise TypeError, "specialized function type error"
        end

        ar = @environment[fn_name][@environment[fn_name].size - 1]
        return ar
      end
      raise TypeError, "function type error"
    end

    def if(_, condition, true_clause, false_clause, type)
      if(validate(condition) <= Bool and validate(true_clause)==validate(false_clause))
        return validate(true_clause)
      end
    raise TypeError, "if statement type error"
    end

    def list(_, expressions, type)
      ex =expressions.map{|expression| validate(expression) }

      cmptype = ex[0]
      if( ex.all?{|t| t == cmptype})
        if(cmptype <= Number) #add special types of list here
          return NumberList
        end
        return List
      end
    raise TypeError, "list type error"

    end

    def not(_, expression, type)
      if(validate(expression) ==Bool)
        return Bool

      end
      raise TypeError, "NOT expression type error"
    end

    def null(_, _, type)
      return type
    end

    def number(_, number, type)
      return type
    end

    def percent(_, percent, type)
      return type
    end

    def string(_, string, type)
      return type
    end

    def variable(_, name, type)
      raise UndefinedVariableError, "undefined variable #{name}" unless @environment.key?(name)
      return @environment[name]
    end











  end
end
