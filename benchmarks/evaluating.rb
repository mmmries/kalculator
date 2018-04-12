require "benchmark/ips"
require "calc"

numbers = Calc.new("5 + 8 / 3 - 1 * 4")
variables = Calc.new("a + b / c - d * e")
variables_data = {"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5}
multi_parts = Calc.new("a.a.a + a.a.b / a.b.a - a.b.b * b.a.a")
multi_parts_data = {"a" => {"a" => {"a" => 1, "b" => 2}, "b" => {"a" => 3, "b" => 4}}, "b" => {"a" => {"a" => 5}}}

Benchmark.ips do |x|
  x.warmup = 2
  x.time = 10

  x.report("eval numbers and operators") do
    numbers.evaluate
  end
  x.report("eval names and operators") do
    variables.evaluate(variables_data)
  end
  x.report("eval multi-part-names and operators") do
    multi_parts.evaluate(multi_parts_data)
  end
end
