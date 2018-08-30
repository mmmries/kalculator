RSpec.describe Kalculator::Formula do
  describe "contains" do
    context "with strings" do
      it "returns true when there is a match" do
        expect(Kalculator.evaluate("contains(\"ohai\", \"oh\")")).to eq(true)
      end

      it "returns false when there is no match" do
        expect(Kalculator.evaluate("contains(\"ohai\", \"Dwight\")")).to eq(false)
      end

      it "handles incorrect types on string" do
        data = {"a" => 1, "b" => "wat"}
        expect { Kalculator.evaluate("contains(a, b)", data) }.to raise_error(Kalculator::TypeError)
      end

      it "handles incorrect types on substring" do
        data = {"a" => "hey", "b" => 4}
        expect { Kalculator.evaluate("contains(a, b)", data) }.to raise_error(Kalculator::TypeError)
      end
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

    it "handles incorrect container type" do
      expect {
        Kalculator.evaluate("sum(\"wat\")")
      }.to raise_error(Kalculator::TypeError, "sum only works with lists of numbers, got \"wat\"")
    end

    it "handles incorrect array contents" do
      expect {
        Kalculator.evaluate("sum(numbers)", {"numbers" => [1,2,"wat"]})
      }.to raise_error(Kalculator::TypeError, "sum only works with lists of numbers, got [1, 2, \"wat\"]")
    end
  end
end
