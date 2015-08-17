require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase

  test 'index responds with list of Activities' do
    user = User.create
    act1 = Activity.create(user_id: user.id)
    act2 = Activity.create(user_id: user.id)
    Activity.create(user_id: user.id+1)

    get(:index, {'user_id' => user.id})

    assert_response :success
    assert_equal [act1, act2].to_json, @response.body


    get(:index, {'user_id' => 654654})

    assert_response :success
    assert_equal [].to_json, @response.body
  end

  test 'show activity' do
    user = User.create
    act1 = Activity.create(user_id: user.id)

    get(:show, {'user_id' => user.id, 'id' => act1.id})

    assert_response :success
    assert_equal act1.to_json, @response.body

  #   get(:show, {'user_id' => user.id, 'id' => 6876})
  #
  #   assert_response :success
  #   assert_equal '{}', @response.body
  end

  test 'model class' do
    assert_equal Activity, @controller.model_class
  end

  test 'permitted parameters' do
    assert_equal [:start_time, :end_time, :timesheet_id, :story_card_id, :user_id], @controller.permitted_parameters
  end

end
