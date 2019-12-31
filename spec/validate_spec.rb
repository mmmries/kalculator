RSpec.describe Kalculator do
  describe "Validating" do
    it "validates mathematic expressions" do
      calc = Kalculator.new("(5 + 4) / 2")
      expect(calc.validate).to eq(Kalculator::Number)
      calc2 = Kalculator.new("(5 + 4) / \"a number\"")
      expect{calc2.validate}.to raise_error(Kalculator::TypeError)

    end
    it "validates boolean expressions" do
      expect(Kalculator.validate("(true OR false) AND true")).to eq(Kalculator::Bool)
      expect{Kalculator.validate("(true OR false) AND \"bob\"")}.to raise_error(Kalculator::TypeError)
    end
    it "validates exists()" do
      formula = "if(exists(Recurring), true, false)"
      expect(Kalculator.validate(formula)).to eq(Kalculator::Bool)
    end
    it "validates lists to be all the same type" do
      expect(Kalculator.validate("[1,2,3,4,5]")).to eq(Kalculator::List.new(Kalculator::Number))
      expect{Kalculator.validate("[1,2,3,4,\"Hello\"]")}.to raise_error(Kalculator::TypeError)

    end
    it "validates built in functions using TypeSources" do
      expect(Kalculator.validate("count(numbers)", Kalculator::TypeSources.new({"numbers" => Kalculator::List.new(Kalculator::Number)}))).to eq(Kalculator::Number)
      expect{Kalculator.validate("count(numbers)", Kalculator::TypeSources.new({"numbers" => Kalculator::String}))}.to raise_error(Kalculator::TypeError)
    end
    it "validates objects using TypeSources" do
      expect(Kalculator.validate("bob", Kalculator::TypeSources.new({"bob"=>Kalculator::MappedObject.new({"name"=> Kalculator::String.new})}))).to eq(Kalculator::MappedObject.new({"name"=> Kalculator::String.new}))
      expect(Kalculator.validate("bob.name", Kalculator::TypeSources.new({"bob"=>Kalculator::MappedObject.new({"name"=> Kalculator::String.new})}))).to eq(Kalculator::String.new)
    end
    it "validates super complex expressions using TypeSources" do
      formula= "!if(bob.mother[\"name\"], true, false) and (bob.age <= 50 or bob.age >= 23)"
      typeSources = Kalculator::TypeSources.new({"bob"=>Kalculator::MappedObject.new({"age"=> Kalculator::Number, "mother"=>Kalculator::MappedObject.new({"name"=>Kalculator::String.new})})})

      expect(Kalculator.validate(formula, typeSources)).to eq(Kalculator::Bool)

    end
  end
end
