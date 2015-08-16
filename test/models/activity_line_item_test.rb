require 'test_helper'

class ActivityLineItemTest  < ActiveSupport::TestCase

  test 'gets activities for story card and timesheet' do
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

    assert_equal [act1, act2], activity_line_item_1.activities
    assert_equal 2.25, activity_line_item_1.billable_hours
    assert_equal story1, activity_line_item_1.story_card

    assert_equal [act3], activity_line_item_2.activities
    assert_equal 2.0, activity_line_item_2.billable_hours
    assert_equal story2, activity_line_item_2.story_card

    assert_equal [], activity_line_item_3.activities
    assert_equal 0.0, activity_line_item_3.billable_hours
    assert_equal story3, activity_line_item_3.story_card
  end

  def timeOn hours, minutes
    return DateTime.new(2015, 1, 1, hours, minutes, 0).new_offset(0)
  end

  test 'csv string' do
    project = Project.create(name: 'Mouse', client: 'Mickey', invoiceNumber: 'SOW123', purchaseOrderNumber: 'ASDF00234')
    timesheet = Timesheet.create(startDate: DateTime.new(2015, 1, 1), throughDate: DateTime.new(2015, 1, 1))
    story1 = StoryCard.create(project_id: project.id, number: '002')
    act1 = Activity.create(timesheet_id: timesheet.id, story_card_id: story1.id, startTime: timeOn(5, 15), endTime: timeOn(6, 30))
    act2 = Activity.create(timesheet_id: timesheet.id, story_card_id: story1.id, startTime: timeOn(6, 30), endTime: timeOn(7, 30))
    activity_line_item_1 = ActivityLineItem.new(timesheet.days[0], story1)

    expected_csv = 'Mickey,SOW123,Mouse DEV - 002,Y,Y,,,,,,2.25,,2.25,2.25,2.25'
    assert_equal expected_csv, activity_line_item_1.to_csv
  end
end