require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase

  test 'index responds with list of Activities' do
    user = User.create
    timesheet = Timesheet.create(user_id: user.id)
    act1 = Activity.create(user_id: user.id, timesheet_id: timesheet.id)
    act2 = Activity.create(user_id: user.id, timesheet_id: timesheet.id)
    Activity.create(user_id: user.id, timesheet_id: 456)
    Activity.create(user_id: user.id+1)

    get(:index, {'user_id' => user.id, 'timesheet_id' => timesheet.id})

    assert_response :success
    assert_equal [act1, act2].to_json, @response.body

    get(:index, {'user_id' => user.id, 'timesheet_id' => timesheet.id})

    assert_response :success
    assert_equal [act1, act2].to_json, @response.body
  end

  test 'create parses start_time and end_time strings correctly' do
    user = User.create
    timesheet = Timesheet.create
    assert_empty Activity.all

    start_time_string = "Thu, 24 Sep 2015 16:36:42 GMT"
    end_time_string = "Thu, 24 Sep 2015 16:45:00 GMT"
    post(:create, {user_id: user.id,
                   timesheet_id: timesheet.id,
                   activity: {
                       start_time: start_time_string,
                       end_time: end_time_string
                   }
                })
    new_activity = Activity.all[0]

    assert_equal DateTime.new(start_time_string), new_activity.start_time
    assert_equal DateTime.new(end_time_string), new_activity.end_time
  end

  test 'show activity' do
    user = User.create
    act1 = Activity.create(user_id: user.id, timesheet_id: 5)

    get(:show, {'user_id' => user.id, 'id' => act1.id, 'timesheet_id'=> 5})

    assert_response :success
    assert_equal act1.to_json, @response.body

  end

  test 'model class' do
    assert_equal Activity, @controller.model_class
  end

  test 'permitted parameters' do
    assert_equal [:start_time, :end_time, :timesheet_id, :story_card_id, :user_id], @controller.permitted_parameters
  end

end
