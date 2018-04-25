RSpec.describe Kalculator::Formula do
  it "memoizes the parsed formula string for faster evaluation" do
    formula = Kalculator::Formula.new("1 + 2")
    expect(formula.ast).to eq([:+, [:number, 1], [:number, 2]])
  end
end
