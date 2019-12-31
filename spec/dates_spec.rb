RSpec.describe "hardcoding dates in a formula" do
  it "can convert strings to dates" do
    expect(Kalculator.evaluate("date(\"2018-01-01\")")).to eq(Date.new(2018,1,1))
  end

  it "raises errors for invalid data" do
    expect {
      Kalculator.validate("date(1234)")
    }.to raise_error(Kalculator::TypeError)
  end

  it "raises errors for invalid dates" do
    expect {
      Kalculator.evaluate("date(\"\")")
    }.to raise_error(ArgumentError, "invalid date")
  end
end
