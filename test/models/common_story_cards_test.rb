require 'test_helper'
require_relative '../../app/models/modules/common_story_cards'

class CommonStoryCardsTest < ActiveSupport::TestCase
  include CommonStoryCards
  attr_accessor :id

  @@expected_billing_cycle = 60 * 15
  @@expected_hour = @@expected_billing_cycle * 4

  test 'card durations' do
    stu = CommonStoryCards::StandUp.new
    assert_equal @@expected_billing_cycle, stu.duration
  end

  test 'common story card numbers' do
    assert_equal 'EST', Estimation.new.number
    assert_equal 'STU', StandUp.new.number
    assert_equal 'KIK', KickOff.new.number
    assert_equal 'PLG', PlanningGame.new.number
    assert_equal 'SHO', ShowNTell.new.number
    assert_equal 'SHP', ShowNTellPrep.new.number
  end

  test 'common story card titles' do
    assert_equal 'Estimation', Estimation.new.title
    assert_equal 'Stand Up', StandUp.new.title
    assert_equal 'Kick Off', KickOff.new.title
    assert_equal 'Planning Game', PlanningGame.new.title
    assert_equal 'Show and Tell', ShowNTell.new.title
    assert_equal 'Show and Tell Prep', ShowNTellPrep.new.title
  end

  test 'estimates' do
    common_cards.each do |eachCard|
      assert_equal 0, eachCard.estimate
    end
  end

  test 'descriptions' do
    common_cards.each do |eachCard|
      assert_equal '', eachCard.description
    end
  end

  test 'initialize_common_cards' do
    common_cards = initialize_common_cards
    assert_equal 6, common_cards.size

  end

  test 'find card with number' do
    self.id = 4444
    expected_card = StoryCard.create(number: 'THK', project_id: 4444)

    actual_card = find_card_with_number 'THK'

    assert_equal expected_card, actual_card

    assert_nil find_card_with_number('HJY')
  end

  test 'lazily inits common story cards by number' do
    project = Project.create
    StoryCard.create(project_id: project.id, number: 'STU')

    project.initialize_common_cards

    assert_equal 6, project.story_cards.size

    assert_equal 'STU', commonCards.number
    assert_equal 'Stand Up', commonCards.title

  end

  test 'common card getter lazily inits common card list' do
    self.id = 55555
    expected_cards = initialize_common_cards
    actual_cards = common_cards

    assert_equal expected_cards, actual_cards
  end
end