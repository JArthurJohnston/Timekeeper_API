require_relative '../../app/models/modules/date_time_helper'

class DateRange
  include DateTimeHelper

  attr_reader :start ,:finish

  def initialize(start, finish)
    @start = start
    @finish = finish
  end

  def contains?(date_time)
    unless date_time.nil? || @start.nil? || @finish.nil?
      return @start < date_time && @finish > date_time
    end
    return false
  end

  def overlaps? date_range
    return contains_range_times?(date_range) || date_range.contains_range_times?(self) || self == date_range
  end

  def contains_range_times?(date_range)
    return self.contains?(date_range.start) || self.contains?(date_range.finish)
  end

  def valid?
    return @start <= @finish
  end

  def == another_date_range
    return self.start == another_date_range.start && self.finish == another_date_range.finish
  end

  def display_string
    return '%{start} to %{end}' % {:start => time_string_for(@start),
                                   :end => time_string_for(@end)}
  end

end