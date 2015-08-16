require 'minitest/autorun'
require_relative '../../config/initializers/core_extensions/date_time/time_rounding'

class TimeRounderTest < MiniTest::Test

  def assertDatesAreEqual expectedDate, actualDate
    #new_offset(0) converts the date to the utc timezone
    assert_equal expectedDate.new_offset(0), actualDate.new_offset(0)
  end

  def test_roundsTimeTo15Minutes
    checkTimeMinutes 0, 0
    checkTimeMinutes 2, 0
    checkTimeMinutes 5, 0
    checkTimeMinutes 7, 0
    checkTimeMinutes 8, 15
    checkTimeMinutes 10, 15
    checkTimeMinutes 23, 30
    checkTimeMinutes 35, 30
    checkTimeMinutes 38, 45
    checkTimeMinutes 48, 45
    checkTimeMinutes 53, 0
  end

  def test_hourIsChangedWhenRoundNearTheHourMark
    aTime = DateTime.new(2015,5,1,1,53,0).rounded_to_fifteen_min
    assert_equal 2, aTime.hour

    aTime = DateTime.new(2015,5,1,1,3,0).rounded_to_fifteen_min
    assert_equal 1, aTime.hour
  end

  def checkTimeMinutes startingMinutes, expectedRoundedMinutes
    aTime = DateTime.new(2015,5,1,1,startingMinutes,0)
    assert_equal expectedRoundedMinutes, aTime.rounded_to_fifteen_min.minute
    assert_equal 0, aTime.rounded_to_fifteen_min.second
  end

  def test_addDays
    aDate = DateTime.new(2015, 1, 1)
    expectedDate = DateTime.new(2015, 1, 2)
    assertDatesAreEqual expectedDate, aDate.add_days(1)

    expectedDate = DateTime.new(2015, 1, 3)
    assertDatesAreEqual expectedDate, aDate.add_days(2)

    aDate = DateTime.new(2015, 12, 31)
    expectedDate = DateTime.new(2016, 1, 1)
    assertDatesAreEqual expectedDate, aDate.add_days(1)
  end

end