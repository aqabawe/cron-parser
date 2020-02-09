# frozen_string_literal: true

require_relative './test_helper'

class TestRuleMatcher < Minitest::Test

  def test_correct_literals
    assert_equal CronParser::RuleMatcher.match('2'), 'literal_parser'
    assert_equal CronParser::RuleMatcher.match('99'), 'literal_parser'
  end

  def test_invalid_literals
    assert_raises RuntimeError do
      CronParser::RuleMatcher.match('-2')
    end
    assert_raises RuntimeError do
      CronParser::RuleMatcher.match('999')
    end
  end

  def test_correct_wildcard
    assert_equal CronParser::RuleMatcher.match('*'), 'wildcard_parser'
    assert_equal CronParser::RuleMatcher.match('*/5'), 'wildcard_parser'
    assert_equal CronParser::RuleMatcher.match('*/12'), 'wildcard_parser'
  end

  def test_invalid_wildcard
    assert_raises RuntimeError do
      CronParser::RuleMatcher.match('*/')
    end
    assert_raises RuntimeError do
      CronParser::RuleMatcher.match('*-1')
    end
    assert_raises RuntimeError do
      CronParser::RuleMatcher.match('*-1/1')
    end
    assert_raises RuntimeError do
      CronParser::RuleMatcher.match('*-/1')
    end
    assert_raises RuntimeError do
      CronParser::RuleMatcher.match('*/999')
    end
  end


  def test_correct_ranges
    assert_equal CronParser::RuleMatcher.match('2-99'), 'range_parser'
    assert_equal CronParser::RuleMatcher.match('22-1'), 'range_parser'
    assert_equal CronParser::RuleMatcher.match('1-5/1'), 'range_parser'
  end

  def test_invalid_ranges
    assert_raises RuntimeError do
      CronParser::RuleMatcher.match('2-5-10')
    end
    assert_raises RuntimeError do
      CronParser::RuleMatcher.match('2-5/')
    end
    assert_raises RuntimeError do
      CronParser::RuleMatcher.match('2-/5')
    end
    assert_raises RuntimeError do
      CronParser::RuleMatcher.match('2-999')
    end
  end
end

