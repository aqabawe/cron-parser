module CronParser
  class Parser
    attr_reader :expression, :minutes, :hours, :day_month, :month, :day_week,
      :command

    def initialize(expression)
      @expression = expression
    end

    def parse
      raise "No expression to parse" unless @expression
      space_split = @expression.strip.split(/\s+/)
      raise "you must provide 6 space seperated values" unless space_split&.size == 6
    end
  end
end
