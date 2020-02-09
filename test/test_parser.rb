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
    assert_equal parser.result[:day_week], (0..6).to_a
  end

  def test_range
    parser = CronParser::Parser.new('5-10 * * * 1-3 bin/blabla')
    parser.parse
    assert_equal parser.result[:minutes], (5..10).to_a
    assert_equal parser.result[:day_week], (1..3).to_a
  end

  def test_invalid_range
    assert_raises RuntimeError do
      parser = CronParser::Parser.new('5-99 * * * 1-3 bin/blabla')
      parser.parse
    end
  end

  def test_range_step
    parser = CronParser::Parser.new('5-20/5 * * * 1-6/2 bin/blabla')
    parser.parse
    assert_equal parser.result[:minutes], [5, 10, 15, 20]
    assert_equal parser.result[:day_week], [1, 3, 5]
  end

  def test_range_zero_step
    assert_raises RuntimeError do
      parser = CronParser::Parser.new('5-20/0 * * * 1-6/2 bin/blabla')
      parser.parse
    end
  end

  def test_range_larger_than_max_step
    assert_raises RuntimeError do
      parser = CronParser::Parser.new('5-20/99 * * * 1-6/2 bin/blabla')
      parser.parse
    end
  end

  def test_list
    parser = CronParser::Parser.new('1,5-10 1-2,4-6 1,2,3,20 1,5-6 1-4,2 bin/blabla')
    parser.parse
    assert_equal parser.result[:minutes], [1, 5, 6, 7, 8, 9, 10]
    assert_equal parser.result[:hours], [1, 2, 4, 5, 6]
    assert_equal parser.result[:day_month], [1, 2, 3, 20]
    assert_equal parser.result[:month], [1, 5, 6]
    assert_equal parser.result[:day_week], [1, 2, 3, 4]
  end
end
