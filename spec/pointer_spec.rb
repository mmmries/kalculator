RSpec.describe Kalculator do
  describe "Pointers" do
    it "points to another variable in the data sources" do
      data = Kalculator::DataSources.new({"a"=>Kalculator::Pointer.new("name"), "name"=>"bob"})
      expect(Kalculator.evaluate("contains(a,\"b\")",data)).to eq(true)
    end
    it "points to another variable in the type_sources" do
      types = Kalculator::TypeSources.new({"a"=>Kalculator::Pointer.new("name"), "name"=>Kalculator::String.new})
      expect(Kalculator.validate("contains(a,\"b\")",types)).to eq(Kalculator::Bool)
    end

    it "points to a piece of data not in the data sources" do
      types = Kalculator::TypeSources.new({"a"=>Kalculator::AnonymousPointer.new(Kalculator::String.new), "name"=>Kalculator::String.new})
      expect(Kalculator.validate("contains(a,\"b\")",types)).to eq(Kalculator::Bool)
    end
  end
end
