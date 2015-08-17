require_relative '../../app/models/modules/attribute_handler'
require_relative '../models/modules/timesheet/current_activity'
require_relative '../../app/models/modules/date_time_helper'

class Timesheet < ActiveRecord::Base
  include AttributeHandler,
          CurrentActivity
  extend DateTimeHelper

  has_many :activities, -> { order('start_time ASC') }
  belongs_to :user

  class << self
    def new_starting aStartDate
      return self.new(start_date: aStartDate, through_date: next_friday_from(aStartDate))
    end

    def create_starting start_date, user_id
      return self.create(start_date: start_date, through_date: next_friday_from(start_date), user_id: user_id)
    end
  end

  def add_activity anActivity
    unless self.current_activity_id.nil?
      self.current_activity.set_end_time anActivity.start_time
    end
    anActivity.set_timesheet self
    setAttribute :current_activity_id, anActivity.id
  end

  def days
    currentDate = self.start_date.to_datetime.new_offset(0)
    through_date = self.through_date.to_datetime.new_offset(0)
    theDays = [self.on(currentDate)]
    while currentDate < through_date
      currentDate += 1.day
      theDays.push(self.on(currentDate.new_offset(0)))
    end
    return theDays
  end

  def on aDate
    return TimesheetDay.new(self, aDate)
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

end
