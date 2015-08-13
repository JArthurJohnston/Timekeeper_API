require_relative '../../app/models/modules/attribute_handler'
require_relative '../models/modules/timesheet/current_activity'
require_relative '../../app/models/modules/date_time_helper'

class Timesheet < ActiveRecord::Base
  include AttributeHandler,
          CurrentActivity,
          DateTimeHelper
  has_many :activities, -> { order('startTime ASC') }
  belongs_to :user

  class << self
    def new_starting aStartDate
      return self.new(startDate: aStartDate, throughDate: next_friday_from(aStartDate))
    end
  end

  def addActivity anActivity
    unless self.current_activity_id.nil?
      self.current_activity.set_end_time anActivity.startTime
    end
    anActivity.set_timesheet self
    setAttribute :current_activity_id, anActivity.id
  end

  def days
    currentDate = self.startDate.to_datetime.new_offset(0)
    throughDate = self.throughDate.to_datetime.new_offset(0)
    theDays = [self.on(currentDate)]
    while currentDate < throughDate
      currentDate += 1.day
      theDays.push(self.on(currentDate.new_offset(0)))
    end
    return theDays
  end

  def on aDate
    return TimesheetDay.new(self, aDate)
  end

  def to_csv
    csvString = ''
    self.story_cards.each do |each_card|
      csvString.concat(StoryCardLineItem.new(each_card, self).to_csv).concat("\n")
    end
    return csvString
  end

  def story_cards
    cards = []
    self.activities.each do |each_activity|
      story_card = each_activity.story_card
      unless cards.include? story_card
        cards.push(story_card)
      end
    end
    return cards
  end

  def destroy
    self.activities.each do
    |each_activity|
      each_activity.destroy
    end
    super
  end

  def activity_updated an_activity
    self.activities.each do
    |each_activity|
      unless an_activity == each_activity
        if an_activity.overlaps? each_activity
          each_activity.update_attributes(:startTime => an_activity.endTime)
          break
        end
      end
    end
  end

  private :dateStringFromDate,
          :getAttribute

end
