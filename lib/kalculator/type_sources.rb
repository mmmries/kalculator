class Kalculator
  class TypeSources

    def initialize(*sources)
      @sources = sources
    end

    def key?(name)
      ret = false
      @sources.each do |source|
        break ret = true if source.key?(name)
      end
      ret
    end

    def [](name)
      ret = nil
      @sources.each do |source|
        break ret = source[name] if source.key?(name)
      end
      ret
    end

    #returns a hash of variable name to type of variable
    def toHash
      a = Hash.new
      @sources.each { |i| a = a.merge(i)}
      return a
    end
  end
end
