RSpec.describe Kalculator::Formula do
  it "memoizes the parsed formula string for faster evaluation" do
    formula = Kalculator::Formula.new("1 + 2")
    expect(formula.ast).to eq([:+, [:number, 1, Kalculator::Number, {:offset=>0..0}], [:number, 2, Kalculator::Number, {:offset=>4..4}], {:offset=>0..4}])
  end
end
