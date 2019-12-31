RSpec.describe Kalculator do
  describe "Parsing" do
    it "parsing basic math structures" do
      calc = Kalculator.new("5 + 4 / 2")
      expect(calc.ast).to eq([:+, [:number, 5, Kalculator::Number, {:offset=>0..0}], [:/, [:number, 4, Kalculator::Number, {:offset=>4..4}], [:number, 2, Kalculator::Number, {:offset=>8..8}], {:offset=>4..8}], {:offset=>0..8}])
    end

    it "uses parentheses to override precendence" do
      calc = Kalculator.new("(5 + 4) / 2")
      expect(calc.ast).to eq([:/, [:+, [:number, 5, Kalculator::Number, {:offset=>1..1}], [:number, 4, Kalculator::Number, {:offset=>5..5}], {:offset=>1..5}], [:number, 2, Kalculator::Number, {:offset=>10..10}], {:offset=>0..10}])
    end

    it "does subtraction" do
      calc = Kalculator.new("14 - 10")
      expect(calc.ast).to eq([:-, [:number, 14, Kalculator::Number, {:offset=>0..1}], [:number, 10, Kalculator::Number, {:offset=>5..6}], {:offset=>0..6}])
    end

    it "parses variable names" do
      calc = Kalculator.new("1 + TotalPrice")
      expect(calc.ast).to eq([:+, [:number, 1, Kalculator::Number, {:offset=>0..0}], [:variable, "TotalPrice", {:offset=>4..13}], {:offset=>0..13}])
    end

    it "parses variable names with dots in them for nested structures" do
      calc = Kalculator.new("a.foo + B.Bar")
      expect(calc.ast).to eq([:+, [:access, "foo", [:variable, "a", {:offset=>0..0}], {:offset=>0..4}], [:access, "Bar", [:variable, "B", {:offset=>8..8}], {:offset=>8..12}], {:offset=>0..12}])
    end

    it "parses negative whole numbers" do
      calc = Kalculator.new("-10")
      expect(calc.ast).to eq([:number, -10, Kalculator::Number, {:offset=>0..2}])
    end

    it "parses negative floating point numbers" do
      expect(Kalculator.new("-1.5").ast).to eq([:number, -1.5, Kalculator::Number, {:offset=>0..3}])
      expect(Kalculator.new("-0.5").ast).to eq([:number, -0.5, Kalculator::Number, {:offset=>0..3}])
      expect(Kalculator.new("-.5").ast).to  eq([:number, -0.5, Kalculator::Number, {:offset=>0..2}])
    end

    it "parses lists" do
      calc = Kalculator.new('[1, 2, 3, 4]')
      expect(calc.ast).to eq([:list, [[:number, 1, Kalculator::Number, {:offset=>1..1}], [:number, 2, Kalculator::Number, {:offset=>4..4}], [:number, 3, Kalculator::Number, {:offset=>7..7}], [:number, 4, Kalculator::Number, {:offset=>10..10}]], {:offset=>0..11}])
    end
  end
end
