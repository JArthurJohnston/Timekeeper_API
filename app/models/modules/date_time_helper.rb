module DateTimeHelper

  MIN_DATE = DateTime.new(1,1,1, 0,0,0)
  MAX_DATE = DateTime.new(9999,12,31, 0,0,0)

  def time_in_minutes(a_time)
    unless a_time.nil?
      dateTime = a_time.to_datetime
        #active record sometimes pulls dates out of the
        #db as TimeWithZone objects, which dont respond to :minute
      return (dateTime.hour * 60) + dateTime.minute
    end
    return 0
  end

  def time_string_for(a_time)
    unless a_time.nil?
      return a_time.strftime("%I:%M")
    end
    return '--'
  end

  def next_friday_from(a_date)
    unless a_date.nil?
      friday_index = 5
      day_index = a_date.to_date.cwday
      if day_index > friday_index
        next_friday_index = 7 + (day_index - friday_index)
      else
        next_friday_index = friday_index - day_index
      end
      return a_date + next_friday_index
    end
    return MAX_DATE
  end

  def parse_date_string date_string
    unless date_string.nil?
      if(date_string.kind_of?(String))
        return DateTime.parse(date_string)
      else
        return date_string
      end
    end
    return MIN_DATE
  end

end