class ActivityLineItem
  attr_reader :activities

  def initialize a_timesheet_day, a_story_card
    @date = a_timesheet_day.date
    @activities = a_timesheet_day.activities.select { |e| e.story_card_id == a_story_card.id }
  end

  def billable_hours
    total_time = 0.0
    @activities.each do |each_activity|
      total_time += each_activity.totalTime
    end
    return total_time
  end

  def date
    return @date.to_datetime.new_offset(0)
  end

end