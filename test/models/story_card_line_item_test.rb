require 'test_helper'

class StoryCardLineItemTest < ActiveSupport::TestCase

  test 'initialize' do
    timesheet = Timesheet.create(startDate: DateTime.new(2015, 1, 1), throughDate: DateTime.new(2015, 1, 1))
    story1 = StoryCard.create
    story2 = StoryCard.create
    story3 = StoryCard.create

    act1 = Activity.create(timesheet_id: timesheet.id, story_card_id: story1.id, startTime: timeOn(5, 15), endTime: timeOn(6, 30))
    act2 = Activity.create(timesheet_id: timesheet.id, story_card_id: story1.id, startTime: timeOn(6, 30), endTime: timeOn(7, 30))
    act3 = Activity.create(timesheet_id: timesheet.id, story_card_id: story2.id, startTime: timeOn(7, 30), endTime: timeOn(9, 30))

    activity_line_item_1 = ActivityLineItem.new(timesheet.days[0], story1)
    activity_line_item_2 = ActivityLineItem.new(timesheet.days[0], story2)
    activity_line_item_3 = ActivityLineItem.new(timesheet.days[0], story3)

    timesheet_day = timesheet.days[0]

    scli = StoryCardLineItem.new(story1, timesheet)

  end
end