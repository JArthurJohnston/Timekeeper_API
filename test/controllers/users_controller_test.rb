require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'create user' do
    post :create, :user => '{"name": "John Smith"}'
    assert_response :success

    created_user = User.find_by(name: 'John Smith')
    assert_not_nil created_user

    assert_equal created_user.to_json, @response.body

  end
end
