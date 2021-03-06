RSpec.describe Kalculator::Formula do
  describe "contains" do
    context "with strings" do
      it "returns true when there is a match" do
        expect(Kalculator.evaluate("contains(\"ohai\", \"oh\")")).to eq(true)
      end

      it "returns false when there is no match" do
        expect(Kalculator.evaluate("contains(\"ohai\", \"Dwight\")")).to eq(false)
      end
    end

    context "with lists" do
      it "can find an integer in a list of integers" do
        expect(Kalculator.evaluate("contains([1,2,3], 2)")).to eq(true)
        expect(Kalculator.evaluate("contains([1,2,3], 4)")).to eq(false)
      end
    end

    it "handles incorrect types on string" do
      data = Kalculator::TypeSources.new({"a" => Kalculator::Number, "b" => Kalculator::String.new})
      begin
        Kalculator.validate("contains(a, b)", data)
      rescue Kalculator::Error => e
        expect(e.class).to be <= (Kalculator::TypeError)
      end

    end

    it "handles incorrect types on substring" do
      data = Kalculator::TypeSources.new({"a" => Kalculator::String.new, "b" => Kalculator::Number})
      begin
        Kalculator.validate("contains(a, b)", data)
      rescue Kalculator::Error => e
        expect(e.class).to be <= (Kalculator::TypeError)
      end
    end
  end

  describe "count" do
    it "can count the entries in a list" do
      expect(Kalculator.evaluate("count(numbers)", {"numbers" => [1,2,3,4]})).to eq(4)
    end

    it "can count the entries in a list literal" do
      expect(Kalculator.evaluate("count([true, false, true, false, true, false])")).to eq(6)
    end

    it "cannot count numbers" do
      expect {
        Kalculator.validate("count(6)")
      }.to raise_error(Kalculator::TypeError)
    end

    it "cannot count strings" do
      expect {
        Kalculator.validate("count(\"ohai\")")
      }.to raise_error(Kalculator::TypeError)
    end
  end

  describe "sum" do
    it "can sum a list of numbers" do
      expect(Kalculator.evaluate("sum(numbers)", {"numbers" => [1,2,3,4]})).to eq(10)
    end

    it "can sum floating point numbers" do
      sum = Kalculator.evaluate("sum(numbers)", {"numbers" => [2,3.5]})
      expect(sum).to be_within(0.01).of(5.5)
    end

    it "can sum over an list literal" do
      sum = Kalculator.evaluate("sum([1, 2, 3, 4, 5])")
      expect(sum).to equal(15)
    end

    it "handles incorrect container type" do
      expect {
        Kalculator.validate("sum(\"wat\")")
      }.to raise_error(Kalculator::TypeError)
    end

    it "handles incorrect array contents" do
      expect {
        Kalculator.validate("sum(numbers)", Kalculator::TypeSources.new({"numbers" => Kalculator::List.new(Object)}))
      }.to raise_error(Kalculator::TypeError)
    end
  end

  describe "max" do
    it "returns the max of two numbers" do
      expect(Kalculator.evaluate("max(18, 20)")).to eq(20)
      expect(Kalculator.evaluate("max(20, 18)")).to eq(20)
      expect(Kalculator.evaluate("max(100.0, 20)")).to eq(100.0)
    end

    it "handles incorrect types" do
      expect {
        Kalculator.validate("max(\"ohai\", 5)")
      }.to raise_error(Kalculator::TypeError)
      expect {
        Kalculator.validate("max(4, [1, 2, 3])")
      }.to raise_error(Kalculator::TypeError)
    end
  end

  describe "min" do
    it "returns the min of two numbers" do
      expect(Kalculator.evaluate("min(18, 20)")).to eq(18)
      expect(Kalculator.evaluate("min(20, 18)")).to eq(18)
      expect(Kalculator.evaluate("min(1.0, 20)")).to eq(1.0)
    end

    it "handles incorrect types" do
      expect {
        Kalculator.validate("min(\"ohai\", 5)")
      }.to raise_error(Kalculator::TypeError)
      expect {
        Kalculator.validate("min(4, [1, 2, 3])")
      }.to raise_error(Kalculator::TypeError)
    end
  end

  it "raises a specific error for undefined functions" do
    expect {
      Kalculator.evaluate("wat(123)")
    }.to raise_error(Kalculator::UndefinedFunctionError, "no such function wat/1")
  end
end
