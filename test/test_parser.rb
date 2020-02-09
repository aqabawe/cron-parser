# frozen_string_literal: true

require_relative './test_helper'

class TestParser < Minitest::Test
  def test_argument_passed
    assert_raises ArgumentError do
      parser = CronParser::Parser.new
      parser.parse
    end
  end

  def test_correct_argument_length
    assert_raises ArgumentError do
      parser = CronParser::Parser.new('1')
      parser.parse
    end
  end

  ## Literal Rule

  def test_correct_literals
    parser = CronParser::Parser.new('59 23 7 12 5 bin/blabla')
    parser.parse
    assert_equal parser.result[:minutes], [59]
    assert_equal parser.result[:hours], [23]
    assert_equal parser.result[:day_month], [7]
    assert_equal parser.result[:month], [12]
    assert_equal parser.result[:day_week], [5]
  end

  def test_literals_out_of_bound
    assert_raises RuntimeError do
      parser = CronParser::Parser.new('99 23 7 12 5 bin/blabla')
      parser.parse
    end
  end

  def test_wildcard
    parser = CronParser::Parser.new('* * * * * bin/blabla')
    parser.parse
    assert_equal parser.result[:minutes], (0..59).to_a
    assert_equal parser.result[:hours], (0..23).to_a
    assert_equal parser.result[:day_month], (1..31).to_a
    assert_equal parser.result[:month], (1..12).to_a
    assert_equal parser.result[:day_week], (0..7).to_a
  end
end
