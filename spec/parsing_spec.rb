RSpec.describe Kalculator do
  describe "Parsing" do
    it "parsing basic math structures" do
      calc = Kalculator.new("5 + 4 / 2")
      expect(calc.ast).to eq([:+, [:number, 5], [:/, [:number, 4], [:number, 2]]])
    end

    it "uses parentheses to override precendence" do
      calc = Kalculator.new("(5 + 4) / 2")
      expect(calc.ast).to eq([:/, [:+, [:number, 5], [:number, 4]], [:number, 2]])
    end

    it "does subtraction" do
      calc = Kalculator.new("14 - 10")
      expect(calc.ast).to eq([:-, [:number, 14], [:number, 10]])
    end

    it "parses variable names" do
      calc = Kalculator.new("1 + TotalPrice")
      expect(calc.ast).to eq([:+, [:number, 1], [:variable, "TotalPrice"]])
    end

    it "parses variable names with dots in them for nested structures" do
      calc = Kalculator.new("a.foo + B.Bar")
      expect(calc.ast).to eq([:+, [:variable, "a.foo"], [:variable, "B.Bar"]])
    end
  end
end
