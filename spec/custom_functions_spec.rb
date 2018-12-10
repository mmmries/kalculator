require "spec_helper"

RSpec.describe "custom functions" do
  it "can accept custom functions" do
    custom = {
      ["wat", 1] => lambda{ |num| num * 2 }
    }
    result = Kalculator.evaluate("wat(5)", {}, custom)
    expect(result).to eq(10)
  end
end
