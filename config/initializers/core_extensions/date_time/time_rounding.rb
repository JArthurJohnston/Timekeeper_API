

class DateTime
  FIFTEEN_MINUTES = 60 * 15.0
  ONE_HOUR = 60 * 60
  ONE_DAY = ONE_HOUR * 24

  def toNearest15
    timestamp = self.to_time.utc.to_i
    roundedTime = (timestamp/FIFTEEN_MINUTES).round * FIFTEEN_MINUTES
    newTime = Time.at(roundedTime).utc
    return newTime.to_datetime
  end

  def addDays aNumber
    timestamp = self.to_time.to_i
    daysToAdd = ONE_DAY * aNumber
    return Time.at(timestamp + daysToAdd).to_datetime
  end

end