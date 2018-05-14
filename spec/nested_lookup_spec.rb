RSpec.describe Kalculator::NestedLookup do
  it "allows for nested key checks" do
    nested = Kalculator::NestedLookup.new({"a" => {"b" => {"c" => 15, "d" => 16}, "e" => 17}})
    expect(nested.key?("a")).to be true
    expect(nested.key?("a.b")).to be true
    expect(nested.key?("a.b.c")).to be true
    expect(nested.key?("a.b.d")).to be true
    expect(nested.key?("a.e")).to be true
    expect(nested.key?("b")).to be false
    expect(nested.key?("a.c")).to be false
  end

  it "allows for nested lookups" do
    nested = Kalculator::NestedLookup.new({"a" => {"b" => {"c" => 15, "d" => 16}, "e" => 17}})
    expect(nested["a"]).to eq({"b" => {"c" => 15, "d" => 16}, "e" => 17})
    expect(nested["a.b"]).to eq({"c" => 15, "d" => 16})
    expect(nested["a.b.c"]).to eq 15
    expect(nested["a.b.d"]).to be 16
    expect(nested["a.e"]).to be 17
    expect(nested["b"]).to be nil
    expect(nested["a.c"]).to be nil
  end
end
