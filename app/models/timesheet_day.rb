class TimesheetDay
  attr_reader :timesheet, :date

  def initialize aTimesheet, aDate
    @timesheet = aTimesheet
    @date = aDate
  end

  def activities
     activities = @timesheet.activities
     return activities.select { |e|
       daysAreTheSame e.startTime.to_datetime.new_offset(0), @date.to_datetime.new_offset(0)
     }
  end

  def daysAreTheSame aDate, anotherDate
    return justTheDate(aDate) == justTheDate(anotherDate)
  end

  def justTheDate aDate
    return DateTime.new(aDate.year, aDate.month, aDate.day)
  end

  def display_string
    return @date.strftime('%A %B %-d %Y')
  end

  def timesheet_id
    return @timesheet.id
  end

end