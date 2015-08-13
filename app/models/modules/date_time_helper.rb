module DateTimeHelper

  def time_in_minutes aTime
    dateTime = aTime.to_datetime #active record sometimes pulls dates out of the
    #db as TimeWithZone objects, which dont respond to :minute
    return (dateTime.hour * 60) + dateTime.minute
  end

  def time_string_for aTime
    unless aTime.nil?
      return aTime.strftime("%I:%M")
    end
    return '--'
  end

  def next_friday_from aDate
    friday = 5
    startDayOfWeek = aDate.to_date.cwday
    if startDayOfWeek > friday
      nextFriday = 7 + (startDayOfWeek - friday)
    else
      nextFriday = friday - startDayOfWeek
    end
    return aDate + nextFriday
  end

end