RSpec.describe Calc::DataSources do
  it "combines multiple data sources" do
    source = Calc::DataSources.new({"a" => 5}, {"c" => 7})
    expect(source.key?("a")).to be true
    expect(source.key?("b")).to be false
    expect(source.key?("c")).to be true
    expect(source["a"]).to eq(5)
    expect(source["b"]).to eq(nil)
    expect(source["c"]).to eq(7)
  end
end
