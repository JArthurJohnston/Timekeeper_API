require_relative 'model_test_case'

class ActivityTest < ModelTestCase

  test 'activity initializes with start and end' do
    expectedStart = DateTime.new(2015, 1, 1, 2, 2, 2)
    expectedEnd = DateTime.new(2015, 1, 1, 3, 3, 3)

    activity = Activity.new(start_time: expectedStart, end_time: expectedEnd)

    assert_equal expectedStart.toNearest15, activity.start_time
    assert_equal expectedEnd.toNearest15, activity.end_time
  end

  test 'input and retrieval from database' do
    expectedStart = DateTime.new(2015, 1, 1, 2, 2, 2).toNearest15
    expectedEnd = DateTime.new(2015, 1, 1, 3, 3, 3).toNearest15

    activity = Activity.new(start_time: expectedStart, end_time: expectedEnd)
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

    assertDatesAreClose now, activity.start_time
    assert_equal nil, activity.end_time
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

    activity = Activity.new(start_time: expectedStart, end_time: expectedEnd)

    assert_equal 0, activity.start_time.minute
    assert_equal 15, activity.end_time.minute
  end

  test 'no args initialize' do
    activity = Activity.new
    assert_nil activity.start_time
    assert_nil activity.end_time
  end

  test 'handles initialize without start or end times' do
    expectedStart = DateTime.new(2015, 1, 1, 2, 2, 2).toNearest15
    expectedEnd = DateTime.new(2015, 1, 1, 3, 3, 3).toNearest15

    activity = Activity.new(start_time: expectedStart)
    assert_equal expectedStart, activity.start_time
    assert_nil activity.end_time

    activity = Activity.new(end_time: expectedEnd)
    assert_equal expectedEnd, activity.end_time
    assert_nil activity.start_time
  end

  test 'index display string' do
    start_time = time_on 9, 15
    end_time = time_on 13, 30
    project = Project.create(name: 'Green Lantern')
    storyCard = StoryCard.new(project: project, number: '2814')
    storyCard.save

    activity = Activity.new start_time: start_time, end_time: end_time, story_card_id: storyCard.id

    assert_equal 'Green Lantern : 2814 : 09:15 to 01:30', activity.display_string

    activity.end_time= nil

    assert_equal 'Green Lantern : 2814 : 09:15 to --', activity.display_string
  end

  test 'activity calculates total time' do
    startingTime = time_on(5, 45)
    endingTime = time_on(7, 30)
    activity = Activity.create(start_time: startingTime, end_time: endingTime)
    assert_equal 1.75, activity.totalTime

    activity.end_time= nil
    activity.save
    assert_equal Float::INFINITY, activity.totalTime

    activity.start_time= startingTime
    activity.save
    assert_equal Float::INFINITY, activity.totalTime

    activity.start_time= nil
    activity.end_time= nil
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
    sow = StatementOfWork.create(client: 'Mickey', number: 'SOW123', purchase_order_number: 'ASDF00234')
    project = Project.create(name: 'Mouse', statement_of_work_id: sow.id)
    story = StoryCard.create(project_id: project.id, number: '002')
    start_date = DateTime.new(2015, 6, 29, 5, 0, 0).new_offset(0)
    end_date = DateTime.new(2015, 6, 29, 5, 15, 0).new_offset(0)
    activity = Activity.create(story_card_id: story.id, start_time: start_date, end_time: end_date)

    expectedCSV = 'Mickey,SOW123,Mouse DEV - 002,Y,Y,,,0.25,,,,,0.25,0.25,0.25'
    actualCSV = activity.to_csv

    assert_equal expectedCSV, actualCSV

    start_date = DateTime.new(2015, 7, 1, 5, 0, 0).new_offset(0)
    end_date = DateTime.new(2015, 7, 1, 5, 30, 0).new_offset(0)
    activity = Activity.create(story_card_id: story.id, start_time: start_date, end_time: end_date)

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

    assert_nil timesheet.current_activity

    assert_nil Timesheet.find(timesheet.id).current_activity_id
  end

  test 'activities overlap' do
    act1 = Activity.create(start_time: time_on(5, 15), end_time: time_on(6, 0))
    act2 = Activity.create(start_time: time_on(5, 45), end_time: time_on(7, 0))
    act3 = Activity.create(start_time: time_on(6, 45), end_time: time_on(8, 0))

    assert act1.overlaps? act2
    deny act1.overlaps? act3
  end

  test 'activity date range' do
    start = time_on(5, 15)
    finish = time_on(6, 0)
    act1 = Activity.create(start_time: start, end_time: finish)

    range = act1.range

    assert_equal start, range.start
    assert_equal finish, range.finish
  end

end
