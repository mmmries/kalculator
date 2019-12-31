class Kalculator
  class Error < ::StandardError ##an error that holds metadata
    attr_reader :metadata
    def initialize(metadata)
      @metadata = metadata
    end
  end
  class TypeError < Error; end
  class UndefinedFunctionError < Error; end
  class UndefinedVariableError < Error; end
end
