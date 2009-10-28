require 'treetop'
require 'rubel_parser'

module Rubel
  class Evaluator
    def initialize
      @expression_cache = {}
    end
    def evaluate(expression, options = {})
      context = options[:with] || {}
      parsed_expression = (@expression_cache[expression] ||= rubel_parser.parse(expression))
      parsed_expression.value(context) unless parsed_expression.nil?
    end
  private
    def rubel_parser
      @rubel_parser ||= RubelParser.new
    end
  end
end