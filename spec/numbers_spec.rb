RSpec.describe "parsing and evaluating numbers" do
  context "percents" do
    it "handles whole percents" do
      expect(Kalculator.parse("2%")).to eq([:percent, 2, Kalculator::Percent, {:offset=>0..1}])
      expect(Kalculator.evaluate("2%")).to eq(0.02)
      expect(Kalculator.parse("125%")).to eq([:percent, 125, Kalculator::Percent, {:offset=>0..3}])
      expect(Kalculator.evaluate("125%")).to eq(1.25)
    end

    it "handles fractional percents" do
      expect(Kalculator.parse("2.5%")).to eq([:percent, 2.5, Kalculator::Percent, {:offset=>0..3}])
      expect(Kalculator.evaluate("2.5%")).to eq(0.025)
      expect(Kalculator.parse("125.2%")).to eq([:percent, 125.2, Kalculator::Percent, {:offset=>0..5}])
      expect(Kalculator.evaluate("125.2%")).to eq(1.252)
    end

    it "handles fractional percents without leading 0" do
      expect(Kalculator.parse(".5%")).to eq([:percent, 0.5, Kalculator::Percent, {:offset=>0..2}])
      expect(Kalculator.evaluate(".5%")).to eq(0.005)
      expect(Kalculator.parse(".002%")).to eq([:percent, 0.002, Kalculator::Percent, {:offset=>0..4}])
      expect(Kalculator.evaluate(".002%")).to eq(0.00002)
    end

    it "handles negative percents" do
      expect(Kalculator.parse("-2%")).to eq([:percent, -2, Kalculator::Percent, {:offset=>0..2}])
      expect(Kalculator.evaluate("-2%")).to eq(-0.02)
      expect(Kalculator.parse("-.5%")).to eq([:percent, -0.5, Kalculator::Percent, {:offset=>0..3}])
      expect(Kalculator.evaluate("-.5%")).to eq(-0.005)
      expect(Kalculator.parse("-1.002%")).to eq([:percent, -1.002, Kalculator::Percent, {:offset=>0..6}])
      expect(Kalculator.evaluate("-1.002%")).to eq(-0.01002)
    end

    it "requires the percent to be right next to the number" do
      expect {
        Kalculator.evaluate("2 %")
      }.to raise_error(RLTK::LexingError)
    end
  end
end
