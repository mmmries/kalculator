RSpec.describe "Boolean Operators" do
  it "evaluates true" do
    expect(Kalculator.evaluate("true")).to be true
    expect(Kalculator.evaluate("TRUE")).to be true
  end

  it "evaluates false" do
    expect(Kalculator.evaluate("false")).to be false
    expect(Kalculator.evaluate("FALSE")).to be false
  end

  it "evaluates >" do
    expect(Kalculator.evaluate("4 > 4")).to eq(false)
    expect(Kalculator.evaluate("5 > 4")).to eq(true)
  end

  it "evaluates >=" do
    expect(Kalculator.evaluate("3 >= 4")).to eq(false)
    expect(Kalculator.evaluate("4 >= 4")).to eq(true)
  end

  it "evaluates <" do
    expect(Kalculator.evaluate("4 < 4")).to eq(false)
    expect(Kalculator.evaluate("4 < 5")).to eq(true)
  end

  it "evaluates <=" do
    expect(Kalculator.evaluate("4 <= 3")).to eq(false)
    expect(Kalculator.evaluate("4 <= 4")).to eq(true)
  end

  it "evaluates ==" do
    expect(Kalculator.evaluate("4 == 3")).to eq(false)
    expect(Kalculator.evaluate("4 == 4")).to eq(true)
  end

  it "evaluates !=" do
    expect(Kalculator.evaluate('"Ohai" != "Wat"')).to eq(true)
    expect(Kalculator.evaluate('"Wat" != "Wat"')).to eq(false)
  end

  it "evaluates AND" do
    expect(Kalculator.evaluate("true AND true")).to eq(true)
    expect(Kalculator.evaluate("true and false")).to eq(false)
    expect(Kalculator.evaluate("false AND false")).to eq(false)
    expect(Kalculator.evaluate("A < 5 and contains(B, C)", {"A" => 4, "B" => "abc", "C" => "b"})).to eq(true)
    expect(Kalculator.evaluate("A < 5 AND contains(B, C)", {"A" => 4, "B" => "abc", "C" => "z"})).to eq(false)
  end

  it "evaluates OR" do
    expect(Kalculator.evaluate("true OR true")).to eq(true)
    expect(Kalculator.evaluate("true or false")).to eq(true)
    expect(Kalculator.evaluate("false or false")).to eq(false)
    expect(Kalculator.evaluate("A < 5 OR contains(B, C)", {"A" => 6, "B" => "abc", "C" => "b"})).to eq(true)
    expect(Kalculator.evaluate("A < 5 OR contains(B, C)", {"A" => 6, "B" => "abc", "C" => "z"})).to eq(false)
  end

  it "evaluates combinations of ANDs and ORs" do
    expect(Kalculator.evaluate("(true OR false) AND true")).to eq(true)
    expect(Kalculator.evaluate("(true OR false) AND false")).to eq(false)
    expect(Kalculator.evaluate("(true AND false) OR false")).to eq(false)
    expect(Kalculator.evaluate("(true AND false) OR true")).to eq(true)
  end

  it "evaluates ! expressions" do
    expect(Kalculator.evaluate("!false")).to eq(true)
    expect(Kalculator.evaluate("!true")).to eq(false)
    expect(Kalculator.evaluate("!A", {"A" => true})).to eq(false)
  end
end
