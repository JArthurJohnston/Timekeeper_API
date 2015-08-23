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
        return self.new(start_time: DateTime.now)
    end
  end

  def initialize attributes = nil, options = {}
    unless attributes.nil?
      if_not_nil_round attributes, :start_time
      if_not_nil_round attributes, :end_time
    end
    super attributes, options
  end

  def range
    return DateRange.new(self.start_time, self.end_time)
  end

  def overlaps? another_activity
    return self.range.overlaps? another_activity.range
  end

  def timeDisplayString
    return self.range.display_string
  end

  def totalTime
    end_time = self.end_time
    start_time = self.start_time
    unless end_time.nil? || start_time.nil?
      return (time_in_minutes(end_time) - time_in_minutes(start_time)) / 60.0
    end
    return Float::INFINITY
  end

  def set_end_time aDateTime
    if self.end_time.nil?
      self.end_time= aDateTime
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

  def destroy
    if self.timesheet.current_activity_id == self.id
      self.timesheet.current_activity_id= nil
      self.timesheet.save
    end
    super
  end

  private

    def round_time_attributes attributes
      original_start_time = attributes[:start_time]
      original_end_time = attributes[:end_time]
      attributes.delete(:start_time)
      attributes.delete(:end_time)

    end

    def if_not_nil_round attributes_passed_in, time_method_symbol
      unless attributes_passed_in[time_method_symbol].nil?
        parsed_date = date_from_attribute(attributes_passed_in[time_method_symbol]).rounded_to_fifteen_min
        attributes_passed_in[time_method_symbol] = parsed_date
      end
    end

    def date_from_attribute attribute
      if(attribute.kind_of?(String))
        return DateTime.parse(attribute)
      else
        return attribute
      end
    end

end
