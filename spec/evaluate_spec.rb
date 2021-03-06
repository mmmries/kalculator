RSpec.describe Kalculator do
  describe "Evaluation" do
    it "evaluates numbers" do
      expect(Kalculator.evaluate("18")).to eq(18)
    end

    it "evaluates addition" do
      expect(Kalculator.evaluate("9 + 9")).to eq(18)
    end

    it "evaluates subtraction" do
      expect(Kalculator.evaluate("9 - 3")).to eq(6)
    end

    it "evaluates multiplication" do
      expect(Kalculator.evaluate("9 * 3")).to eq(27)
    end

    it "evaluates division" do
      expect(Kalculator.evaluate("9 / 3")).to eq(3)
    end

    it "evaluates variables" do
      expect(Kalculator.evaluate("A", {"A" => 4})).to eq(4)
    end

    it "evaluates multi-part variable names" do
      data = {"A" =>{"foo.bar" => 14}}
      expect(Kalculator.evaluate("A[\"foo.bar\"] + 6", data)).to eq(20)
    end

    it "evaluates nested multi-part variable names" do
      data = {"A" => {"foo" => {"bar" => 14}}}
      expect(Kalculator.evaluate("A.foo.bar + 6", data)).to eq(20)
    end

    it "missing names in a nested structure raise UndefinedVariableErrors" do
      data = {"A" => {"foo" => {"bar" => 14}}}
      expect{ Kalculator.evaluate("A.foo.baz + 6", data) }.to raise_error(Kalculator::UndefinedVariableError)
    end

    it "evaluates if" do
      expect(Kalculator.evaluate("if(2 > 1, 1 + 1, 2 + 2)")).to eq(2)
      expect(Kalculator.evaluate("if(1 > 1, 1 + 1, 2 + 2)")).to eq(4)
    end

    it "evaluates nested ifs" do
      formula = 'if(A, if(B, "B True", "B False"), if(C, "C True", "C False"))'
      expect(Kalculator.evaluate(formula, {"A" => true, "B" => true})).to eq("B True")
      expect(Kalculator.evaluate(formula, {"A" => true, "B" => false})).to eq("B False")
      expect(Kalculator.evaluate(formula, {"A" => false, "C" => true})).to eq("C True")
      expect(Kalculator.evaluate(formula, {"A" => false, "C" => false})).to eq("C False")
    end

    it "evaluates sum" do
      expect(Kalculator.evaluate("sum(a)", {"a" => [1,2,3,4]})).to eq(10)
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
