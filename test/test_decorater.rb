# frozen_string_literal: true

require_relative './test_helper'

class TestDecorater < Minitest::Test
  def test_correct_initialize
    decorater = CronParser::Decorater.new(
      command: 'bin/blabla',
      minutes: [1],
      hours: [2],
      day_month: [3],
      month: [4],
      day_week: [5]
    )
    assert_equal decorater.minutes, [1]
    assert_equal decorater.hours, [2]
    assert_equal decorater.day_month, [3]
    assert_equal decorater.month, [4]
    assert_equal decorater.day_week, [5]
    assert_equal decorater.command, 'bin/blabla'
  end

  def test_invalid_initialize
    assert_raises ArgumentError do
      CronParser::Decorater.new(command: 'bin/blabla')
    end
  end
end
