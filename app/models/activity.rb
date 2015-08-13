require_relative 'date_range'
require_relative '../../app/models/modules/date_time_helper'

class Activity < ActiveRecord::Base
  include DateTimeHelper

  belongs_to :story_card
  belongs_to :timesheet
  belongs_to :user

  BILLING_CYCLE = 15.0 * 60

  class << self
    def now
        return self.new(startTime: DateTime.now)
    end
  end

  def initialize attributes = nil, options = {}
    unless attributes.nil?
      if_not_nil_round attributes, :startTime
      if_not_nil_round attributes, :endTime
    end
    super attributes, options
  end


  def update_attributes(attributes)
    super attributes
    self.timesheet.activity_updated(self)
  end

  def indexDisplayString
    return "%{projectNumber} : %{start} to %{end}" % {:projectNumber => self.story_card.projectNumber,
                                                      :start => time_string_for(self.startTime),
                                                      :end => time_string_for(self.endTime)}
  end

  def range
    return DateRange.new(self.startTime, self.endTime)
  end

  def overlaps? another_activity
    return self.range.overlaps? another_activity.range
  end

  def timeDisplayString
    return self.range.display_string
  end

  def totalTime
    end_time = self.endTime
    start_time = self.startTime
    unless end_time.nil? || start_time.nil?
      return (time_in_minutes(end_time) - time_in_minutes(start_time)) / 60.0
    end
    return Float::INFINITY
  end

  def set_end_time aDateTime
    if self.endTime.nil?
      self.endTime= aDateTime
      self.save
    end
  end

  def set_timesheet aTimesheet
    self.timesheet_id = aTimesheet.id
    self.save
  end

  def project
    unless self.story_card.nil?
      return self.story_card.project
    end
  end

  def to_csv
    return "%{client}%{activity}%{billable}%{weekDays}%{totals}" %
        {:client => client_columns,
        :activity => activity_string,
        :billable => billable_columns_string,
        :weekDays => self.weekday_hours_string,
        :totals => self.total_string}
  end

  def billable_columns_string
    return 'Y,Y,'
  end

  def activity_string
    return "%{name} DEV - %{code}," % {:name => self.project.name,
                                      :code => self.story_card.number}
  end

  def client_columns
    return "%{name},%{code}," % {:name => self.project.client,
                                :code => self.project.invoiceNumber}
  end

  def total_string
    return "%{tots},%{tots},%{tots}" % {:tots => self.totalTime}
  end

  def weekday_hours_string
    weekdayString = ','
    myDate = self.startTime.to_datetime.new_offset(0)
    (0..5).each do |i|
      if myDate.cwday == i
        weekdayString.concat(self.totalTime)
      end
      weekdayString.concat(',')
    end
    return weekdayString
  end

  def destroy
    if self.timesheet.current_activity_id == self.id
      self.timesheet.current_activity_id= nil
      self.timesheet.save
    end
    super
  end

  private

    def if_not_nil_round attributes, aSymbol
      unless attributes[aSymbol].nil?
        attributes[aSymbol] = attributes[aSymbol].toNearest15
      end
    end

end
