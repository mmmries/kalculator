require "benchmark/ips"
require "calc"

Benchmark.ips do |x|
  x.warmup = 2
  x.time = 10

  x.report("parse numbers and operators") do
    Calc.new("5 + 8 / 3 - 1 * 4")
  end
  x.report("parsing names and operators") do
    Calc.new("a + b / c - d * e")
  end
  x.report("parsing multi-part-names and operators") do
    Calc.new("a.b.c + b.c.d / c.d.e - d.e.f * e.f.g")
  end
end
