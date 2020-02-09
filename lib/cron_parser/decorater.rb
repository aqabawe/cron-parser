# frozen_string_literal: true

module CronParser
  # This class is used to output the data parsed by the parser class.
  # We can as many methods as we like to represent different outputs.
  class Decorater
    attr_reader :command, :minutes, :hours, :day_week, :day_month, :month
    REQUIRED_KEYS = %i[command day_month day_week hours minutes month].freeze

    def initialize(parsed_data = {})
      # Validate parsed data
      REQUIRED_KEYS.each do |key|
        unless parsed_data.key?(key)
          raise ArgumentError, "Required key: #{key.inspect}"
        end
      end

      @minutes   = parsed_data[:minutes]
      @hours     = parsed_data[:hours]
      @day_month = parsed_data[:day_month]
      @month     = parsed_data[:month]
      @day_week  = parsed_data[:day_week]
      @command   = parsed_data[:command]
    end

    def to_table
      puts "minute       #{@minutes.join(' ')}"
      puts "hours        #{@hours.join(' ')}"
      puts "day of month #{@day_month.join(' ')}"
      puts "month        #{@month.join(' ')}"
      puts "day of week  #{@day_week.join(' ')}"
      puts "command      #{@command}"
    end
  end
end
