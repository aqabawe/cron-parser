# frozen_string_literal: true

module CronParser
  # Cron rules matcher:
  # - *: A field may contain an asterisk (*), which always stands for
  # "first-last".
  #
  # - Literal: a digit that falls within the min-max for that field.
  #
  # - Range: Ranges are two numbers separated with a hyphen. The specified
  #  range is inclusive.
  #
  # - List: A list is set of numbers (or ranges) separated by commas.
  class RuleMatcher
    RULES = [
      {
        regex: Regexp.new('^\*$'),
        parser: 'wildcard_parser'
      },
      {
        regex: Regexp.new('^\d*\-\d*(\/\d*)?$'),
        parser: 'range_parser'
      },

      {
        regex: Regexp.new('^\d*$'),
        parser: 'literal_parser'
      }
    ].freeze

    class << self
      def match(expression)
        RULES.each do |rule|
          return rule[:parser] unless expression.match(rule[:regex]).nil?
        end
        raise "Expression: '#{expression}' did not match any rules"
      end
    end
  end
end
