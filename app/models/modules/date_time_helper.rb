module DateTimeHelper

  def time_in_minutes(a_time)
    dateTime = a_time.to_datetime #active record sometimes pulls dates out of the
    #db as TimeWithZone objects, which dont respond to :minute
    return (dateTime.hour * 60) + dateTime.minute
  end

  def time_string_for(a_time)
    unless a_time.nil?
      return a_time.strftime("%I:%M")
    end
    return '--'
  end

  def next_friday_from(a_date)
    friday = 5
    startDayOfWeek = a_date.to_date.cwday
    if startDayOfWeek > friday
      nextFriday = 7 + (startDayOfWeek - friday)
    else
      nextFriday = friday - startDayOfWeek
    end
    return a_date + nextFriday
  end

end