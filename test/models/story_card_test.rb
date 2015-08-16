require_relative 'model_test_case'

class StoryCardTest < ModelTestCase

  def setup
    @storyCard = StoryCard.create(title: 'Build Lego',
                              number: '001',
                              description: 'make the things',
                              estimate: 4)
  end

  test 'story card fields' do
    project = Project.create
    description = 'you need to do all the things'
    cardNumber = 'D123'
    title = 'do something with the thing'
    estimate = 16
    storyCard = StoryCard.new(project_id: project.id, title: title, number: cardNumber, description: description, estimate: estimate)

    assert_equal title, storyCard.title
    assert_equal cardNumber, storyCard.number
    assert_equal description, storyCard.description
    assert_equal estimate, storyCard.estimate
    assert_equal project, storyCard.project
  end

  test 'story card activities' do
    assert_empty @storyCard.activities

    newActivity1 = Activity.create(story_card_id: @storyCard.id)
    newActivity2 = Activity.create(story_card_id: @storyCard.id)
    newActivity3 = Activity.create(story_card_id: @storyCard.id)

    assert_equal 3, @storyCard.activities.size
    assert @storyCard.activities.include? newActivity1
    assert @storyCard.activities.include? newActivity2
    assert @storyCard.activities.include? newActivity3
  end

  test 'billable hours on card' do
    @storyCard.save
    activity1 = Activity.create(start_time: time_on(5, 45), end_time: time_on(7, 30), story_card_id: @storyCard.id)
    activity2 = Activity.create(start_time: time_on(5, 00), end_time: time_on(7, 00), story_card_id: @storyCard.id)
    activity3 = Activity.create(start_time: time_on(7, 00), end_time: time_on(7, 30), story_card_id: @storyCard.id)
    activity4 = Activity.create(start_time: time_on(7, 00), end_time: nil, story_card_id: @storyCard.id)

    assert_equal 4.25, @storyCard.billable_hours
  end

end
