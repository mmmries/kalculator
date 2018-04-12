RSpec.describe Calc do
  it "has a shortcut for evaluating a formula directly" do
    expect(Calc.evaluate("1 + a", {"a" => 1})).to eq(2)
  end
end
