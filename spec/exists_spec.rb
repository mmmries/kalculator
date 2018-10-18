require "spec_helper"

RSpec.describe "exists()" do
  it "allows a formula to check for the existience of a variable" do
    formula = "if(exists(Recurring), Recurring, false)"
    expect(Kalculator.evaluate(formula, {"Recurring" => true})).to eq(true)
    expect(Kalculator.evaluate(formula, {"Recurring" => false})).to eq(false)
    expect(Kalculator.evaluate(formula, {})).to eq(false)
  end
end
