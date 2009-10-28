require 'test/unit'

require 'rubygems'
require 'rubel'

require 'benchmark'

class RubelTest < Test::Unit::TestCase
  def setup
    @rubel = Rubel::Evaluator.new
  end
  def test_rubel
    result = @rubel.evaluate 'my_identifier', :with => {:my_identifier => 42}
    assert_equal 42, result
  end
  def test_benchmark
    Benchmark.realtime do
      10000.times do
        # A simple expression
        @rubel.evaluate 'my_identifier', :with => {:my_identifier => 42}
        # A path expression
        @rubel.evaluate 'foo.bar', :with => {:foo => {:bar => 42}}
        # A rather complex expression
        @rubel.evaluate '(foo.bar or (a > b)) and (foo.bar or (b < a))', :with => {:foo => {:bar => false}, :a => 1, :b => 2}
      end
    end
  end
end