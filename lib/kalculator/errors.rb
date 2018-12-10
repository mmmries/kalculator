class Kalculator
  class Error < ::StandardError; end
  class TypeError < Error; end
  class UndefinedFunctionError < Error; end
  class UndefinedVariableError < Error; end
end
