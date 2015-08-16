require_relative 'model_test_case'

class ActivityTest < ModelTestCase

  test 'activity initializes with start and end' do
    expectedStart = DateTime.new(2015, 1, 1, 2, 2, 2)
    expectedEnd = DateTime.new(2015, 1, 1, 3, 3, 3)

    activity = Activity.new(startTime: expectedStart, endTime: expectedEnd)

    assert_equal expectedStart.toNearest15, activity.startTime
    assert_equal expectedEnd.toNearest15, activity.endTime
  end

  test 'input and retrieval from database' do
    expectedStart = DateTime.new(2015, 1, 1, 2, 2, 2).toNearest15
    expectedEnd = DateTime.new(2015, 1, 1, 3, 3, 3).toNearest15

    activity = Activity.new(startTime: expectedStart, endTime: expectedEnd)
    activity.save

    activityFromDB = Activity.find(activity.id)

    assert_equal activity, activityFromDB
  end

  test 'belongs to a story card and a timesheet' do
    timesheet = Timesheet.new()
    timesheet.save
    storyCard = StoryCard.new()
    storyCard.save

    activity = Activity.new
    activity.story_card_id = storyCard.id
    activity.timesheet_id = timesheet.id

    assert_equal storyCard, activity.story_card
    assert_equal timesheet, activity.timesheet
  end

  test 'activity starts now' do
    now = DateTime.now.toNearest15
    activity = Activity.now

    assertDatesAreClose now, activity.startTime
    assert_equal nil, activity.endTime
  end

  def assertDatesAreClose expectedDate, actualDate
    assert_equal expectedDate.utc.year, actualDate.utc.year
    assert_equal expectedDate.utc.month, actualDate.utc.month
    assert_equal expectedDate.utc.day, actualDate.utc.day
    assert_equal expectedDate.utc.hour, actualDate.utc.hour
    assert_equal expectedDate.utc.minute, actualDate.utc.minute
    assert_equal expectedDate.utc.second, actualDate.utc.second
  end

  test 'initialize rounds times to nearest 15' do
    expectedStart = DateTime.new(2015, 1, 1, 2, 2, 2)
    expectedEnd = DateTime.new(2015, 1, 1, 3, 8, 3)

    activity = Activity.new(startTime: expectedStart, endTime: expectedEnd)

    assert_equal 0, activity.startTime.minute
    assert_equal 15, activity.endTime.minute
  end

  test 'no args initialize' do
    activity = Activity.new
    assert_nil activity.startTime
    assert_nil activity.endTime
  end

  test 'handles initialize without start or end times' do
    expectedStart = DateTime.new(2015, 1, 1, 2, 2, 2).toNearest15
    expectedEnd = DateTime.new(2015, 1, 1, 3, 3, 3).toNearest15

    activity = Activity.new(startTime: expectedStart)
    assert_equal expectedStart, activity.startTime
    assert_nil activity.endTime

    activity = Activity.new(endTime: expectedEnd)
    assert_equal expectedEnd, activity.endTime
    assert_nil activity.startTime
  end

  test 'set end time' do
    activity = Activity.create
    expectedTime = DateTime.now
    anotherTime = DateTime.new(2015, 5, 5)

    activity.setEndTime expectedTime
    assert_equal expectedTime, activity.endTime

    activity.setEndTime anotherTime
    assert_equal expectedTime, activity.endTime
  end

  test 'setEndTime doesnt set end if end is already set' do
    activity = Activity.new
    expectedTime = dateTimeOn 5, 5
    unexpectedTiem = dateTimeOn 6, 6

    activity.setEndTime expectedTime
    activity.setEndTime unexpectedTiem

    assert_equal expectedTime, activity.endTime
  end

  test 'set timesheet' do
    timesheet = Timesheet.create

    activity = Activity.create
    activity.setTimesheet timesheet

    assert_equal timesheet.id, activity.timesheet_id
    assert_equal timesheet, activity.timesheet
  end

  test 'index display string' do
    startTime = dateTimeOn 9, 15
    endTime = dateTimeOn 13, 30
    project = Project.create(name: 'Green Lantern')
    storyCard = StoryCard.new(project: project, number: '2814')
    storyCard.save

    activity = Activity.new startTime: startTime, endTime: endTime, story_card_id: storyCard.id

    assert_equal 'Green Lantern : 2814 : 05:15 to 09:30', activity.indexDisplayString

    activity.endTime= nil

    assert_equal 'Green Lantern : 2814 : 05:15 to --', activity.indexDisplayString
  end

  def dateTimeOn hours, minutes
    timeNow = DateTime.now
    return DateTime.new timeNow.year, timeNow.month, timeNow.day, hours, minutes, 0
  end

  test 'activity calculates total time' do
    startingTime = dateTimeOn(5, 45)
    endingTime = dateTimeOn(7, 30)
    activity = Activity.create(startTime: startingTime, endTime: endingTime)
    assert_equal 1.75, activity.totalTime

    activity.endTime= nil
    activity.save
    assert_equal Float::INFINITY, activity.totalTime

    activity.startTime= startingTime
    activity.save
    assert_equal Float::INFINITY, activity.totalTime

    activity.startTime= nil
    activity.endTime= nil
    activity.save
    assert_equal Float::INFINITY, activity.totalTime
  end

  test 'activity has project' do
    assert_nil Activity.create.project

    project = Project.create
    storyCard = StoryCard.create(project_id: project.id)
    activity = Activity.create(story_card_id: storyCard.id)

    assert_equal(project, activity.project)
  end

  test 'to csv ' do
    project = Project.create(name: 'Mouse', client: 'Mickey', invoiceNumber: 'SOW123', purchaseOrderNumber: 'ASDF00234')
    story = StoryCard.create(project_id: project.id, number: '002')
    start_date = DateTime.new(2015, 6, 29, 5, 0, 0).new_offset(0)
    end_date = DateTime.new(2015, 6, 29, 5, 15, 0).new_offset(0)
    activity = Activity.create(story_card_id: story.id, startTime: start_date, endTime: end_date)

    expectedCSV = 'Mickey,SOW123,Mouse DEV - 002,Y,Y,,,0.25,,,,,0.25,0.25,0.25'
    actualCSV = activity.to_csv

    assert_equal expectedCSV, actualCSV

    start_date = DateTime.new(2015, 7, 1, 5, 0, 0).new_offset(0)
    end_date = DateTime.new(2015, 7, 1, 5, 30, 0).new_offset(0)
    activity = Activity.create(story_card_id: story.id, startTime: start_date, endTime: end_date)

    expectedCSV = 'Mickey,SOW123,Mouse DEV - 002,Y,Y,,,,,0.5,,,0.5,0.5,0.5'
    actualCSV = activity.to_csv

    assert_equal expectedCSV, actualCSV
  end

  test 'deleting an activity will clear the current activity id if the activity is current' do
    timesheet = Timesheet.create
    act1 = Activity.create
    act2 = Activity.create
    act3 = Activity.create
    timesheet.add_activity(act1)
    timesheet.add_activity(act2)
    timesheet.add_activity(act3)

    assert_equal act3, timesheet.current_activity

    act2.destroy
    assert_equal act3, timesheet.current_activity

    act3.destroy
    assert_raises ActiveRecord::RecordNotFound do
      timesheet.current_activity
    end

    assert_nil Timesheet.find(timesheet.id).current_activity_id
  end

  test 'activities overlap' do
    act1 = Activity.create(startTime: time_on(5, 15), endTime: time_on(6, 0))
    act2 = Activity.create(startTime: time_on(5, 45), endTime: time_on(7, 0))
    act3 = Activity.create(startTime: time_on(6, 45), endTime: time_on(8, 0))

    assert act1.overlaps? act2
    deny act1.overlaps? act3
  end

  test 'activity date range' do
    start = time_on(5, 15)
    finish = time_on(6, 0)
    act1 = Activity.create(startTime: start, endTime: finish)

    range = act1.range

    assert_equal start, range.start
    assert_equal finish, range.finish
  end

  test 'updating an activity calls activity_updated on timesheet' do
    timesheet = MockTimesheet.new
    activity = Activity.new
    activity.timesheet= timesheet

    activity.update_attributes(:startTime => time_on(3, 30))

    assert timesheet.activity_updated_was_called
    assert_equal activity, timesheet.activity_passed_in
  end

  class MockTimesheet < Timesheet
    attr_reader :activity_passed_in,
                :activity_updated_was_called

    def activity_updated activity_passed_in
      @activity_passed_in = activity_passed_in
      @activity_updated_was_called = true
    end

  end

end
