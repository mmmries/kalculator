RSpec.describe Kalculator do
  describe "Nested variables" do
    it "can be accessed using the accessor operator" do
      dataSources = Kalculator::DataSources.new({"bob"=>{"age"=> 5, "mother"=>{"name"=>"susan"}}})
      expect(Kalculator.evaluate("bob.mother.name", dataSources)).to eq("susan")
    end
    it "are added to the type sources with a MappedObject type" do
      typeSources = Kalculator::TypeSources.new({"bob"=>Kalculator::MappedObject.new({"age"=> Kalculator::Number, "mother"=>Kalculator::MappedObject.new({"name"=>Kalculator::String.new})})})
      expect(Kalculator.validate("bob.mother.name", typeSources)).to eq(Kalculator::String.new)
    end
    it "can be accessed using an alternate type of accessor" do
      dataSources = Kalculator::DataSources.new({"bob"=>{"age"=> 5, "mother"=>{"name"=>"susan"}}})
      expect(Kalculator.evaluate("bob.mother[\"name\"]", dataSources)).to eq("susan")
    end
  end
end
