class Kalculator
  class NestedLookup
    def initialize(data_source)
      @data_source = data_source
    end

    def key?(name)
      names = name.split(".")
      source = @data_source
      names.all? do |name|
        break false unless source.key?(name)
        source = source[name]
        true
      end
    end

    def [](name)
      names = name.split(".")
      names.inject(@data_source) do |source, name|
        break nil unless source.key?(name)
        source[name]
      end
    end
  end
end
