require 'test_helper'
require_relative 'setup_integration_models'

class CreateTestsTest < ActionDispatch::IntegrationTest
  include SetupIntegrationModels
  # test "the truth" do
  #   assert true
  # end

  def setup
    setup_models
  end

  #/users/:user_id/statements_of_work
  test 'create SOW' do
    new_sow_json = '{"user_id":1, "number":"222", "purchase_order_number":"345", "client":"Harold"}'

    assert_nil StatementOfWork.find_by(user_id: @user1.id, number: "222", purchase_order_number: "345", client: "Harold")
    assert_equal 3, StatementOfWork.all.size

    post '/users/1/statements_of_work', new_sow_json, json_header

    assert_response :success
    assert_equal 4, StatementOfWork.all.size
    assert_not_nil StatementOfWork.find_by(user_id: @user1.id, number: "222", purchase_order_number: "345", client: "Harold")
  end

  #/users/:user_id/timesheets/:timesheet_id/activities
  test 'create activities' do
    expected_start_date = 'Sun, 23 Aug 2019 00:46:13 GMT'
    expected_end_date = 'Mon, 24 Aug 2019 00:54:13 GMT'

    new_activity_json = '{"start_time": "'+expected_start_date+'",
"end_time":"'+expected_end_date+'",
"user_id":' +@user1.id.to_s+ ',
"timesheet_id":' + @timesheet1.id.to_s + ',
"story_card_id":' + @story1.id.to_s + '}'

    assert_equal 3, @timesheet1.activities.size

    post '/users/1/timesheets/1/activities', new_activity_json, json_header

    assert_response :success
    assert_equal 4, @timesheet1.activities.size

    expected_start_date = DateTime.parse(expected_start_date).rounded_to_fifteen_min
    expected_end_date = DateTime.parse(expected_end_date).rounded_to_fifteen_min
    new_activity = @timesheet1.activities.last

    assert_equal new_activity.start_time, expected_start_date
    assert_equal new_activity.end_time, expected_end_date
    assert_equal @story1.id, new_activity.story_card_id
    assert_equal @timesheet1.id, new_activity.timesheet_id
    assert_equal @user1.id, new_activity.user_id
  end

  test 'create projects' do
    new_project_json = '{"name":"Awesome Sauce", "statement_of_work_id": ' +@sow1.id.to_s+ '}'
    assert_equal 3, Project.all.size

    post '/projects', new_project_json, json_header

    assert_equal 4, Project.all.size

    assert_equal 'Awesome Sauce', Project.all.last.name
  end

  test 'create story card' do
    new_story_json = '{"project_id":' + @project1.id.to_s + ',
"number":"666",
"title":"The sign of the beast",
"description":"Prepare for the comming of the anti-christ",
"estimate":16 }'

    assert_equal 3, StoryCard.all.size

    post '/projects/1/story_cards', new_story_json, json_header

    assert_equal 4, StoryCard.all.size

    new_story = StoryCard.all.last
    assert_equal '666', new_story.number
    assert_equal 'The sign of the beast', new_story.title
    assert_equal 'Prepare for the comming of the anti-christ', new_story.description
    assert_equal 16, new_story.estimate
    assert_equal @project1.id, new_story.project_id
  end

  test 'create timesheet' do
    start_date_string = "Sun, 23 Aug 2019 00:46:13 GMT"
    end_date_string = 'Tue, 25 Aug 2019 00:54:13 GMT'

    new_timesheet_json = '{"start_date":"'+start_date_string+'",
"through_date":"'+ end_date_string +'",
"user_id":' + @user1.id.to_s + '}'

    assert_equal 3, Timesheet.all.size

    post '/users/1/timesheets', new_timesheet_json, json_header

    assert_equal 4, Timesheet.all.size
    expected_start_date = DateTime.parse(start_date_string)
    expected_through_date = DateTime.parse(end_date_string)
    actual_timesheet = Timesheet.all.last

    assert_equal expected_start_date, actual_timesheet.start_date
    assert_equal expected_through_date, actual_timesheet.through_date
    assert_equal @user1.id, actual_timesheet.user_id
  end

end
