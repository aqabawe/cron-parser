# frozen_string_literal: true

module CronParser
  # Parser class: Here we attempt to parse the different parts of the cron
  # expression.
  class Parser
    attr_reader :expression, :result

    PARTS = [
      { name: :minutes, min: 0, max: 59 },
      { name: :hours, min: 0, max: 23 },
      { name: :day_month, min: 1, max: 31 },
      { name: :month, min: 1, max: 12 },
      { name: :day_week, min: 0, max: 7 }
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
        @result[part[:name]] = send(parser, val, part[:min], part[:max])
      end
    end

    def literal_parser(val, min, max)
      val = val.to_i

      unless val >= min && val <= max
        raise "Expression: #{val} is out of bounds"
      end

      [val]
    end

    def wildcard_parser(_val, min, max)
      (min..max).to_a
    end

    def range_parser(val, min, max)
      step = 1
      sections = val.split('/')
      step = sections.last.to_i if sections.size > 1
      # Step validations
      raise "Step too large for #{val}" if step > max
      raise "Step cannot be zero: #{val}" if step.zero?

      range_start, range_end = sections.first.split('-').map(&:to_i)
      # Range validation
      [range_start, range_end].each do |bound|
        unless bound >= min && bound <= max
          raise "Expression: #{val} is out of bounds"
        end
      end

      (range_start..range_end).step(step).to_a
    end
  end
end
