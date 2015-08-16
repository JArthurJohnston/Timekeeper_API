require 'test_helper'

class StoryCardTest < ActiveSupport::TestCase
  # test 'the truth' do
  #   assert true
  # end

  def setup
    @storyCard = StoryCard.new(title: 'Build Lego',
                              number: '001',
                              description: 'make the things',
                              estimate: 4)
  end

  test 'initialized with name, number, and description' do
    description = 'you need to do all the things'
    cardNumber = 'D123'
    title = 'do something with the thing'
    estimate = 16
    storyCard = StoryCard.new(title: title, number: cardNumber, description: description, estimate: estimate)

    assert_equal title, storyCard.title
    assert_equal cardNumber, storyCard.number
    assert_equal description, storyCard.description
    assert_equal estimate, storyCard.estimate
  end

  test 'story card has project' do
    project = Project.new(name: '', invoiceNumber: '' , client: '')
    project.save
    projectId = project.id

    @storyCard.project_id= project.id

    assert_equal projectId, @storyCard.project_id
    assert_equal project, @storyCard.project
  end

  test 'project number string' do
    project = Project.create(name: 'Green Lantern')
    storyCard = StoryCard.new(number: '2814', project: project)

    assert_equal 'Green Lantern : 2814', storyCard.projectNumber
  end

  test 'story card activities' do
    assert_empty @storyCard.activities
    @storyCard.save

    newActivity1 = newActivityForStoryCard
    newActivity2 = newActivityForStoryCard
    newActivity3 = newActivityForStoryCard

    assert_equal 3, @storyCard.activities.size
    assert @storyCard.activities.include? newActivity1
    assert @storyCard.activities.include? newActivity2
    assert @storyCard.activities.include? newActivity3
  end

  test 'index display string' do
    project = Project.create(name: 'Builder')
    @storyCard.project_id = project.id
    @storyCard.save
    assert_equal 'Builder : 001 : Build Lego : 4', @storyCard.indexDisplayString
  end

  test 'billable hours on card' do
    @storyCard.save
    activity1 = Activity.create(startTime: dateTimeOn(5, 45), endTime: dateTimeOn(7, 30), story_card_id: @storyCard.id)
    activity2 = Activity.create(startTime: dateTimeOn(5, 00), endTime: dateTimeOn(7, 00), story_card_id: @storyCard.id)
    activity3 = Activity.create(startTime: dateTimeOn(7, 00), endTime: dateTimeOn(7, 30), story_card_id: @storyCard.id)
    activity4 = Activity.create(startTime: dateTimeOn(7, 00), endTime: nil, story_card_id: @storyCard.id)
    assert_equal 4.25, @storyCard.billableHours
  end

  test 'create common card' do
    fail 'write me'
  end

  def newActivityForStoryCard
    newActivity = Activity.create
    newActivity.story_card_id = @storyCard.id
    newActivity.save
    return newActivity
  end

  test 'cant delete story card which has activities' do
    story_card = StoryCard.create
    assert story_card.can_be_deleted

    act1 = Activity.create(story_card_id: story_card.id)

    assert_false story_card.can_be_deleted
  end

  def dateTimeOn hours, minutes
    timeNow = DateTime.now
    return DateTime.new timeNow.year, timeNow.month, timeNow.day, hours, minutes, 0
  end

end
