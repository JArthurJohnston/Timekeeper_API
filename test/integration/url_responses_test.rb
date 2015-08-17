require 'test_helper'

class UrlResponsesTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = User.create(name: 'John Doe')
    @user2 = User.create(name: 'Jane Doe')

    @timesheet1 = Timesheet.create(start_date: DateTime.new_starting(2015, 1,1), user_id: @user1.id)
    @timesheet2 = Timesheet.create(start_date: DateTime.new_starting(2015, 1,1), user_id: @user1.id)
    @timesheet3 = Timesheet.create(start_date: DateTime.new_starting(2015, 1,1), user_id: @user2.id)
  end

  test 'user index' do
    get '/users'

    assert_response :success
    assert_equal [@user1, @user2].to_json, @response.body
  end

  test 'timesheet index' do
    get '/usert/' + @user1.id.to_s + '/timesheets'

    assert_response :success
    assert_equal [@timesheet1, @timesheet2].to_json, @response.body
  end

end
