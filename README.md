# Kalculator

A rubygem to safely and quickly evaluate mathematical and logical expressions entered by a user.
This library is very similar to [dentaku](https://github.com/rubysolo/dentaku) in purpose, but it emphasizes simplicity and performance.

## Changes in 0.4.0

Before 0.4.0 it was possible to pass in a multi-part name like:

```ruby
Kalculator.evaluate("a.b" => {"a" => {"b" => 15}}) # => 15
```

Looking up names this way restricts certain use-cases, so we've moved this functionality out of the way we evaluate and into a helper class.
Now you can do either of the following:

```
# names are looked up in their complete form
Kalculator.evaluate("a.b" => {"a.b" => 15}}) # => 15
# the NestedLookup class splits names into parts and looks them up in a nested way
Kalculator.evaluate("a.b" => Kalculator::NestedLookup.new({"a" => {"b" => 15}})) # => 15
```

## Basic Usage

```ruby
Kalculator.evaluate("5 + 8 - 3") # => 10
Kalculator.evaluate("A * C", {"A" => 1, "C" => 8}) # => 8
```

If you have an expression that you want to execute multiple times (ie run the same calculation on a bunch of different datasets), you can create a `Kalculator` instance which will memoize the parsed AST.

```ruby
kalculator = Kalculator.new("13 * Price - Taxes")
kalculator.evaluate({"Price" => 8.5, "Taxes" => 1.35}) # => 109.15
```

## Performance

This project emphasizes performance and includes a few benchmarks.
You can run these like this:

```
bundle exec ruby benchmarks/parsing.rb
```

The last time I compared these benchmarks against the performance of `dentaku` I found that the performance was ~17.5x faster when evaluating expressions and about the same when parsing them.

![iterations per second](performance_vs_dentaku.png)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmmries/kalculator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kalculator project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mmmries/kalculator/blob/master/CODE_OF_CONDUCT.md).
