class Calc
  class DataSources
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
  end
end
