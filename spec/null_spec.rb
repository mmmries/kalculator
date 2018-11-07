RSpec.describe "parsing and evaluating nulls" do
  it "can parse a null" do
    expect(Kalculator.evaluate("null")).to be_nil
    expect(Kalculator.evaluate("NULL")).to be_nil
  end

  it "can compare null" do
    expect(Kalculator.evaluate("a == null", {"a" => nil})).to eq(true)
    expect(Kalculator.evaluate("a == null", {"a" => 123})).to eq(false)
  end

  it "can match nil in a list" do
    expect(Kalculator.evaluate("contains(list, null)", {"list" => [1, 2, nil]})).to eq(true)
    expect(Kalculator.evaluate("contains(list, null)", {"list" => [1, 2, 3]})).to eq(false)
  end
end
