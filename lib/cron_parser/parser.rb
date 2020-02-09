# frozen_string_literal: true

module CronParser
  # Parser class: Here we attempt to parse the different parts of the cron
  # expression.
  class Parser
    attr_reader :expression, :result

    PARTS = [
      { name: :minutes, min: 0, max: 59 },
      { name: :hours, min: 0, max: 23 },
      { name: :day_month, min: 0, max: 31 },
      { name: :month, min: 0, max: 12 },
      { name: :day_week, min: 0, max: 7 },
    ].freeze

    def initialize(expression)
      @expression = expression
      @result = {}
    end

    def parse
      raise ArguementError, 'No expression to parse' unless @expression

      space_split = @expression.strip.split(/\s+/)

      unless space_split&.size == 6
        raise ArgumentError, 'you must provide 6 space seperated values'
      end

      @result[:command] = space_split.last

      space_split[0..4].each_with_index do |val, index|
        parser = RuleMatcher.match(val)
        part = PARTS[index]
        @result[part[:name]] = self.send(
          parser,
          val,
          part[:min],
          part[:max]
        )
      end
    end

    def literal_parser(val, min, max)
      val = val.to_i

      unless val >= min && val <= max
        raise "Expression: #{val} is out of bounds"
      end

      return [val]
    end
  end
end
