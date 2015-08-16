require_relative 'model_test_case'
require_relative '../../app/models/date_range'

class DateRangeTest < ModelTestCase

  test 'initialize' do
    time1 = time_on(5, 15)
    time2 = time_on(6, 30)

    range = DateRange.new(time1, time2)

    assert_equal(time1, range.start)
    assert_equal(time2, range.finish)
  end

  test 'range contains time' do
    time1 = time_on(5, 15)
    time2 = time_on(6, 30)
    outside_time = time_on(7, 30)
    contained_time = time_on(6, 0)

    range = DateRange.new(time1, time2)

    deny range.contains?(outside_time)
    assert range.contains?(contained_time)

    deny range.contains?(time_on(5, 15))
    deny range.contains?(time_on(6, 30))
  end

  test 'date ranges overlap' do
    time1 = time_on(5, 15)
    time2 = time_on(6, 30)
    range = DateRange.new(time1, time2)
    overlapped_range = DateRange.new(time_on(5, 30), time_on(6, 15))

    assert range.overlaps?(overlapped_range)
    assert overlapped_range.overlaps?(range)

    outside_range1 = DateRange.new(time_on(6, 30), time_on(7, 45))
    outside_range2 = DateRange.new(time_on(4, 30), time_on(5, 15))

    deny range.overlaps? outside_range1
    deny range.overlaps? outside_range2

    overlaps_start_range = DateRange.new(time_on(4, 30), time_on(5, 45))
    assert range.overlaps? overlaps_start_range

    overlaps_end_range = DateRange.new(time_on(5, 45), time_on(7, 15))
    assert range.overlaps? overlaps_end_range

    start_time = time_on(5, 45)
    finish_time = time_on(6, 45)
    dr1 = DateRange.new(start_time, finish_time)
    dr2 = DateRange.new(start_time, finish_time)
    assert dr1.overlaps? dr2

    deny dr1.overlaps?(DateRange.new(nil, nil))
  end

  test 'equality' do
    start_time = time_on(5, 45)
    finish_time = time_on(6, 45)
    dr1 = DateRange.new(start_time, finish_time)
    dr2 = DateRange.new(start_time, finish_time)

    assert dr1 == dr2

    dr3 = DateRange.new(time_on(5, 45), time_on(6, 45))
    dr4 = DateRange.new(time_on(3, 45), time_on(5, 15))

    deny dr3 == dr4
  end

  test 'date range is valid' do
    valid_range = DateRange.new(time_on(6, 30), time_on(7, 45))
    assert valid_range.valid?

    valid_range2 = DateRange.new(time_on(6, 30), time_on(6, 30))
    assert valid_range2.valid?

    invalid_range = DateRange.new(time_on(6, 30), time_on(4, 45))
    deny invalid_range.valid?
  end

  test 'range returns min or max when start and finish are nil' do
    assert_equal DateTime.new(1,1,1, 0, 0, 0), DateRange.MIN_DATE
    assert_equal DateTime.new(9999,12,31, 24, 59, 99), DateRange.MAX_DATE

    finish = time_on(8, 45)
    start = time_on(5, 45)
    d_range = DateRange.new(start, finish)


  end

end