RSpec.describe Kalculator do
  it "has a shortcut for evaluating a formula directly" do
    expect(Kalculator.evaluate("1 + a", {"a" => 1})).to eq(2)
  end

  it "has a backwards-compatible .new method for creating formulas" do
    expect(Kalculator.new("1 + a").evaluate({"a" => 2})).to eq(3)
  end
end
