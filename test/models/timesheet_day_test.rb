require 'test_helper'

class TimesheetDayTest < ActiveSupport::TestCase

  @@base_date = DateTime.new(2015, 1, 1).new_offset(0)

  def setup
    @timesheet = Timesheet.create
    Activity.create(timesheet_id: @timesheet.id, start_time: @@base_date)
    Activity.create(timesheet_id: @timesheet.id, start_time: @@base_date)
  end

  test 'timesheet days from timesheet' do
    timesheetDate = DateTime.new(2015, 1, 1)
    timesheetDay = TimesheetDay.new(@timesheet, timesheetDate)
    assert_equal @timesheet, timesheetDay.instance_variable_get(:@timesheet)
    assert_equal timesheetDate, timesheetDay.instance_variable_get(:@date)
  end

  test 'activites' do
    timesheet = Timesheet.create
    starting_date = DateTime.new(2015, 1, 1)

    act1 = Activity.create(timesheet_id: timesheet.id, start_time: starting_date)
    act2 = Activity.create(timesheet_id: timesheet.id, start_time: starting_date)
    act3 = Activity.create(timesheet_id: timesheet.id, start_time: starting_date)
    act4 = Activity.create(timesheet_id: timesheet.id, start_time: DateTime.new(2015, 1, 2))

    timesheetDay = TimesheetDay.new(timesheet, starting_date)
    assert_equal 3, timesheetDay.activities.size
    expectedActivities = [act1, act2, act3]
    assert_equal expectedActivities, timesheetDay.activities
  end

  test 'display string' do
    timesheetDay = TimesheetDay.new nil, DateTime.new(2015, 1, 1).new_offset(0)

    assert_equal 'Thursday January 1 2015', timesheetDay.display_string
  end

end
