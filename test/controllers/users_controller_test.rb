require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test 'create user' do
    post :create, :user => '{"name": "John Smith"}'
    assert_response :success

    created_user = User.find_by(name: 'John Smith')
    assert_not_nil created_user

    assert_equal created_user.to_json, @response.body
  end

  test 'update user' do
    user = User.create(name: 'Kyle Raynor')

    post :update, :id => user.id, :user => '{"name": "Alan Scott"}'

    assert_response :success
    assert_equal 'Alan Scott', User.find(user.id).name
  end

  test 'show user' do
    user = User.create(name: 'Kyle Raynor')

    get :show, :id => user.id

    assert_response :success
    assert_equal user.to_json, @response.body
  end

  test 'destroy user' do
    user1 = User.create(name: 'Bob')

    post :destroy, :id => user1.id

    assert_response :success
    assert_nil User.find_by(id: user1.id)
    assert_equal '', @response.body
  end

  test 'all users' do
    user1 = User.create(name: 'Bob')
    user2 = User.create(name: 'Villa')

    get :index

    assert_response :success
    assert_equal [user1, user2].to_json, @response.body
  end

end
