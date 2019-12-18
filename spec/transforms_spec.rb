require "spec_helper"

RSpec.describe Kalculator::Transform do
  it "can walk through an entire AST" do
    ast = Kalculator.parse("sum(List)")
    new_ast = Kalculator::Transform.run(ast) do |node|
      next [:list, [[:number, 1], [:number, 2]], {}] if node[0] == :variable && node[1] == "List"
      node
    end
    expect(new_ast).to eq([:fn_call, "sum", [[:list, [[:number, 1], [:number, 2]], {}]], {offset: 0..8}])
  end

  it "can replace items in a list" do
    ast = Kalculator.parse("[Foo, 5, \"hi\"]")
    new_ast = Kalculator::Transform.run(ast) do |node|
      next [:variable, "Bar", node.last] if node.is_a?(Array) && node.first == :variable && node[1] == "Foo"
      next 6 if node == 5
      next [:string, "ohai",String.new, node.last] if node.is_a?(Array) && node.first == :string && node[1] == "hi"
      node
    end
    expect(new_ast).to eq([:list, [
      [:variable, "Bar", {offset: 1..3}],
      [:number, 6, Kalculator::Number, {offset: 6..6}],
      [:string, "ohai", String.new, {offset: 9..12}]
    ], {offset: 0..13}])
  end

  it "can replace nested nodes" do
    ast = Kalculator.parse("NotBlacklisted AND deal_splits.Revenue.user_id == rep.id")
    new_ast = Kalculator::Transform.run(ast) do |node|
      if node.is_a?(Array) && node.first == :variable && node[1] == "rep"
        [:variable, "bob", node.last]
      else
        node
      end
    end
    expect(new_ast).to eq([:and,
       [:variable,"NotBlacklisted", {:offset=>0..13}],
           [:==,
              [:access, "user_id",
                [:access, "Revenue",
                  [:variable, "deal_splits", {:offset=>19..29}], {:offset=>19..37}], {:offset=>19..45}],
              [:access, "id",
                [:variable, "bob", {:offset=>50..52}], {:offset=>50..55}], {:offset=>19..55}], {:offset=>0..55}]
    )

  end

  it "can replaces variables inside of exists calls" do
    ast = Kalculator.parse("exists(ohai)")
    new_ast = Kalculator::Transform.run(ast) do |node|
      next node unless node.is_a?(Array) && node.first == :variable
      [:variable, "wat"]
    end
    expect(new_ast).to eq([:exists, "ohai", {:offset=>0..11}])
  end
end
