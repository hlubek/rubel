require 'test/unit'

require 'rubygems'
require 'treetop'

Treetop.load('rubel')

class RubelParserTest < Test::Unit::TestCase
  def setup
    @parser = RubelParser.new
  end
  def test_parses_boolean_constant
    tree = @parser.parse 'true'
    assert tree
  end
  def test_boolean_constant_value
    assert_equal false, @parser.parse('false').value({})
    assert_equal true, @parser.parse('true').value({})
  end
  def test_parses_string_in_double_quotes
    tree = @parser.parse '"foo"'
    assert tree
  end
  def test_string_in_double_quotes_value
    assert_equal 'foo', @parser.parse('"foo"').value({})
  end
  def test_string_comparison
    assert_equal true, @parser.parse('"foo" == foo').value({:foo => 'foo'})
    assert_equal true, @parser.parse('foo != ""').value({:foo => 'foo'})
    assert_equal false, @parser.parse('foo != ""').value({:foo => ''})
  end
  def test_parses_integer_number
    tree = @parser.parse '42'
    assert tree
  end
  def test_integer_number_value
    tree = @parser.parse '42'
    assert_equal 42, tree.value({})
  end
  def test_parses_float_number
    tree = @parser.parse '4.2'
    assert tree
  end
  def test_float_number_value
    tree = @parser.parse '4.2'
    assert_equal 4.2, tree.value({})
  end
  def test_parses_identifier
    tree = @parser.parse 'my_identifier'
    assert tree
  end
  def test_identifier_value
    tree = @parser.parse 'my_identifier'
    assert_equal 42, tree.value({'my_identifier' => 42})    
  end
  def test_identifier_value_from_sym
    tree = @parser.parse 'my_identifier'
    assert_equal 42, tree.value({:my_identifier => 42})    
  end
  def test_parses_path
    tree = @parser.parse 'my_path.my_identifier'
    assert tree
  end
  def test_path_value
    tree = @parser.parse 'my_path.my_identifier'
    assert_equal 42, tree.value({'my_path' => {'my_identifier' => 42}})
  end
  def test_parses_equality
    tree = @parser.parse 'a==b'
    assert tree
  end
  def test_equality_value
    tree = @parser.parse 'a==b'
    assert_equal false, tree.value({'a' => 1, 'b' => 0})
    assert_equal true, tree.value({'a' => 1, 'b' => 1})
  end
  def test_parses_equality_with_space
    tree = @parser.parse 'a == b'
    assert tree
  end
  def test_parses_equality_with_subexpression
    tree = @parser.parse '(a == b) == b'
    assert tree
  end
  def test_parses_equality_with_subexpression
    tree = @parser.parse 'a == (a == b)'
    assert tree
  end
  def test_parses_unparenthesed_operators
    tree = @parser.parse 'a != b == c'
    assert tree
  end
  def test_parses_inequality
    tree = @parser.parse 'a != b'
    assert tree
  end
  def test_inequality_value
    tree = @parser.parse 'a != b'
    assert_equal true, tree.value({'a' => 1, 'b' => 0})
    assert_equal false, tree.value({'a' => 1, 'b' => 1})
  end
  def test_parses_comparators
    assert @parser.parse 'a < b'
    assert @parser.parse 'a > b'
    assert @parser.parse 'a <= b'
    assert @parser.parse 'a >= b'
  end
  def test_comparators_values
    assert_equal true, @parser.parse('a < b').value({'a' => 1, 'b' => 2})
    assert_equal false, @parser.parse('a > b').value({'a' => 1, 'b' => 2})
    assert_equal true, @parser.parse('a <= b').value({'a' => 1, 'b' => 1})
    assert_equal false, @parser.parse('a <= b').value({'a' => 2, 'b' => 1})
    assert_equal true, @parser.parse('a >= b').value({'a' => 1, 'b' => 1})
    assert_equal false, @parser.parse('a >= b').value({'a' => 1, 'b' => 2})
  end
  def test_parses_negation
    tree = @parser.parse '!a'
    assert tree
  end
  def test_negation_value
    tree = @parser.parse '!a'
    assert_equal true, tree.value({'a' => false})
  end
  def test_parses_and
    tree = @parser.parse 'a and b'
    assert tree
  end
  def test_and_value
    tree = @parser.parse 'a and b'
    assert_equal false, tree.value({'a' => false, 'b' => true})
    assert_equal true, tree.value({'a' => true, 'b' => true})
  end
  def test_parses_or
    tree = @parser.parse 'a and b'
    assert tree
  end
  def test_or_value
    tree = @parser.parse 'a or b'
    assert_equal true, tree.value({'a' => false, 'b' => true})
    assert_equal false, tree.value({'a' => false, 'b' => false})
  end
  def test_parses_ternary
    tree = @parser.parse 'a ? b : c'
    assert tree
  end
  def test_ternary_value
    tree = @parser.parse 'a ? b : c'
    assert_equal 42, tree.value({'a' => true, 'b' => 42, 'c' => 0})
    assert_equal 0, tree.value({'a' => false, 'b' => 42, 'c' => 0})
  end
end
