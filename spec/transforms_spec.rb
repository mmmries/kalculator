require "spec_helper"

RSpec.describe Kalculator::Transform do
  it "can walk through an entire AST" do
    ast = Kalculator.parse("sum(List)")
    new_ast = Kalculator::Transform.run(ast) do |node|
      next [:list, [[:number, 1], [:number, 2]]] if node == [:variable, "List"]
      node
    end
    expect(new_ast).to eq([:fn_call, "sum", [[:list, [[:number, 1], [:number, 2]]]]])
  end

  it "can replace items in a list" do
    ast = Kalculator.parse("[Foo, 5, \"hi\"]")
    new_ast = Kalculator::Transform.run(ast) do |node|
      next [:variable, "Bar"] if node == [:variable, "Foo"]
      next 6 if node == 5
      next [:string, "ohai"] if node == [:string, "hi"]
      node
    end
    expect(new_ast).to eq([:list, [
      [:variable, "Bar"],
      [:number, 6],
      [:string, "ohai"]
    ]])
  end

  it "can replace nested nodes" do
    ast = Kalculator.parse("NotBlacklisted AND deal_splits.Revenue.user_id == rep.id")
    new_ast = Kalculator::Transform.run(ast) do |node|
      if node.size == 3 && node[1].first == :variable && node[1].last.split(".").size == 3
        (_, type, column) = node[1].last.split(".")
        [:and,
          [node.first,
            [:variable, "deal_splits.#{column}"],
            node[2],
          ],
          [:==,
            [:variable, "deal_split_type.name"],
            [:string, type],
          ],
        ]
      else
        node
      end
    end

    expect(new_ast).to eq([:and,
      [:variable, "NotBlacklisted"],
      [:and,
        [:==,
          [:variable, "deal_splits.user_id"],
          [:variable, "rep.id"],
        ],
        [:==,
          [:variable, "deal_split_type.name"],
          [:string, "Revenue"],
        ]
      ]
    ])
  end

  it "can replaces variables inside of exists calls" do
    ast = Kalculator.parse("exists(ohai)")
    new_ast = Kalculator::Transform.run(ast) do |node|
      next node unless node.is_a?(Array) && node.first == :variable
      [:variable, "wat"]
    end
    expect(new_ast).to eq([:exists, [:variable, "wat"]])
  end
end
