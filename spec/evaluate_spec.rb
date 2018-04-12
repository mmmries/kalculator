RSpec.describe Calc do
  describe "Evaluation" do
    it "evaluates true" do
      expect(Calc.new("true").evaluate).to be true
    end

    it "evaluates false" do
      expect(Calc.new("false").evaluate).to be false
    end

    it "evaluates numbers" do
      expect(Calc.new("18").evaluate).to eq(18)
    end

    it "evaluates addition" do
      expect(Calc.new("9 + 9").evaluate).to eq(18)
    end

    it "evaluates subtraction" do
      expect(Calc.new("9 - 3").evaluate).to eq(6)
    end

    it "evaluates multiplication" do
      expect(Calc.new("9 * 3").evaluate).to eq(27)
    end

    it "evaluates division" do
      expect(Calc.new("9 / 3").evaluate).to eq(3)
    end

    it "evaluates variables" do
      expect(Calc.new("A").evaluate({"A" => 4})).to eq(4)
    end

    it "evaluates multi-part variable names" do
      data = {"A" => {"foo" => {"bar" => 14}}}
      expect(Calc.new("A.foo.bar + 6").evaluate(data)).to eq(20)
    end

    it "evaluates >" do
      expect(Calc.new("4 > 4").evaluate).to eq(false)
      expect(Calc.new("5 > 4").evaluate).to eq(true)
    end

    it "evaluates >=" do
      expect(Calc.new("3 >= 4").evaluate).to eq(false)
      expect(Calc.new("4 >= 4").evaluate).to eq(true)
    end

    it "evaluates <" do
      expect(Calc.new("4 < 4").evaluate).to eq(false)
      expect(Calc.new("4 < 5").evaluate).to eq(true)
    end

    it "evaluates <=" do
      expect(Calc.new("4 <= 3").evaluate).to eq(false)
      expect(Calc.new("4 <= 4").evaluate).to eq(true)
    end

    it "evaluates ==" do
      expect(Calc.new("4 == 3").evaluate).to eq(false)
      expect(Calc.new("4 == 4").evaluate).to eq(true)
    end

    it "evaluates if" do
      expect(Calc.new("if(2 > 1, 1 + 1, 2 + 2)").evaluate).to eq(2)
      expect(Calc.new("if(1 > 1, 1 + 1, 2 + 2)").evaluate).to eq(4)
    end

    it "evaluates sum" do
      expect(Calc.new("sum(a)").evaluate({"a" => [1,2,3,4]})).to eq(10)
    end
  end
end
