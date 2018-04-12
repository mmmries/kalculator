RSpec.describe Kalculator do
  it "has a shortcut for evaluating a formula directly" do
    expect(Kalculator.evaluate("1 + a", {"a" => 1})).to eq(2)
  end
end
