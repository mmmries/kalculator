RSpec.describe Kalculator do
  describe "Evaluation" do
    it "evaluates true" do
      expect(Kalculator.new("true").evaluate).to be true
    end

    it "evaluates false" do
      expect(Kalculator.new("false").evaluate).to be false
    end

    it "evaluates numbers" do
      expect(Kalculator.new("18").evaluate).to eq(18)
    end

    it "evaluates addition" do
      expect(Kalculator.new("9 + 9").evaluate).to eq(18)
    end

    it "evaluates subtraction" do
      expect(Kalculator.new("9 - 3").evaluate).to eq(6)
    end

    it "evaluates multiplication" do
      expect(Kalculator.new("9 * 3").evaluate).to eq(27)
    end

    it "evaluates division" do
      expect(Kalculator.new("9 / 3").evaluate).to eq(3)
    end

    it "evaluates variables" do
      expect(Kalculator.new("A").evaluate({"A" => 4})).to eq(4)
    end

    it "evaluates multi-part variable names" do
      data = {"A" => {"foo" => {"bar" => 14}}}
      expect(Kalculator.new("A.foo.bar + 6").evaluate(data)).to eq(20)
    end

    it "evaluates >" do
      expect(Kalculator.new("4 > 4").evaluate).to eq(false)
      expect(Kalculator.new("5 > 4").evaluate).to eq(true)
    end

    it "evaluates >=" do
      expect(Kalculator.new("3 >= 4").evaluate).to eq(false)
      expect(Kalculator.new("4 >= 4").evaluate).to eq(true)
    end

    it "evaluates <" do
      expect(Kalculator.new("4 < 4").evaluate).to eq(false)
      expect(Kalculator.new("4 < 5").evaluate).to eq(true)
    end

    it "evaluates <=" do
      expect(Kalculator.new("4 <= 3").evaluate).to eq(false)
      expect(Kalculator.new("4 <= 4").evaluate).to eq(true)
    end

    it "evaluates ==" do
      expect(Kalculator.new("4 == 3").evaluate).to eq(false)
      expect(Kalculator.new("4 == 4").evaluate).to eq(true)
    end

    it "evaluates if" do
      expect(Kalculator.new("if(2 > 1, 1 + 1, 2 + 2)").evaluate).to eq(2)
      expect(Kalculator.new("if(1 > 1, 1 + 1, 2 + 2)").evaluate).to eq(4)
    end

    it "evaluates sum" do
      expect(Kalculator.new("sum(a)").evaluate({"a" => [1,2,3,4]})).to eq(10)
    end

    it "can evaluate a string" do
      expect(Kalculator.evaluate("\"ohai\"")).to eq("ohai")
    end

    it "raises a specific error if a variable cannot be found" do
      expect {
        Kalculator.evaluate("wat")
      }.to raise_error(Kalculator::UndefinedVariableError)
    end

    it "can compare strings" do
      expect(Kalculator.evaluate("\"ohai\" == Name", {"Name" => "ohai"})).to eq(true)
      expect(Kalculator.evaluate("\"ohai\" == Name", {"Name" => "kThxBye"})).to eq(false)
    end
  end
end
