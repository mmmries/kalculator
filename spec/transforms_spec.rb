require "spec_helper"

RSpec.describe Kalculator::Transform do
  it "can walk through an entire AST" do
    ast = Kalculator.parse("sum(List)")
    new_ast = Kalculator::Transform.run(ast) do |node|
      if node == [:variable, "List"]
        [:list, [[:number, 1], [:number, 2]]]
      else
        node
      end
    end
    expect(new_ast).to eq([:sum, [:list, [[:number, 1], [:number, 2]]]])
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
end
