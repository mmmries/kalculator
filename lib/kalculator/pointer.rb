class Kalculator
  class Pointer
    attr_reader :p
    def initialize( p)
      @p = p
    end
  end

  class AnonymousPointer
    attr_reader :p

    def initialize(p)
      @p = p
    end
  end
end
