require_relative 'model_test_case'
require_relative '../../app/models/modules/date_time_helper'

class DateTimeHelperTest < ModelTestCase
  include DateTimeHelper

  test 'time in minutes' do
    time  = time_on(5, 15)
    actual_minutes = time_in_minutes(time)

    assert_equal 315, actual_minutes

    assert_equal 0, time_in_minutes(nil)
  end

  test 'time string for' do
    time = time_on(5, 15)
    assert_equal '05:15', time_string_for(time)
    assert_equal '--', time_string_for(nil)
  end

  test 'next friday from' do
    date = DateTime.new(2015, 9, 1)
    expected_friday = DateTime.new(2015, 9, 4)
    assert_equal expected_friday, next_friday_from(date)

    date = DateTime.new(2015, 8, 31)
    assert_equal expected_friday, next_friday_from(date)

    assert_equal expected_friday, next_friday_from(expected_friday)

    assert_equal MAX_DATE, next_friday_from(nil)
  end

  test 'parse date string' do
    date_string = 'Fri, 25 Sep 2015 16:54:55 GMT'
    expected_date = DateTime.new(2015, 9, 25, 16, 54, 55);
    actual_date = parse_date_string date_string

    assert_equal expected_date, actual_date
    assert_equal MIN_DATE, parse_date_string(nil)
  end

  test 'min and max dates' do
    expected_min = DateTime.new(1,1,1, 0,0,0)
    expected_max = DateTime.new(9999,12,31, 0,0,0)

    assert_equal expected_max, MAX_DATE
    assert_equal expected_min, MIN_DATE
  end

end