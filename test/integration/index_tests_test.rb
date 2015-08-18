require 'test_helper'
require_relative 'setup_integration_models'

class IndexTestsTest < ActionDispatch::IntegrationTest
  include SetupIntegrationModels
  # test "the truth" do
  #   assert true
  # end

  def setup
    setup_models
  end

  #/users
  test 'User Index' do
    get '/users'
    assert_response :success
    assert_equal @all_users.to_json, @response.body
  end

  #/users/:user_id/timesheets
  test 'Timesheet Index' do
    get '/users/' + @user1.id.to_s + '/timesheets'
    assert_response :success
    assert_equal [@timesheet1, @timesheet2].to_json, @response.body

    get '/users/' + @user2.id.to_s + '/timesheets'
    assert_response :success
    assert_equal [@timesheet3].to_json, @response.body
  end

  #/users/:user_id/statements_of_work
  test 'SOW index' do
    get '/users/' + @user1.id.to_s + '/statements_of_work'
    assert_response :success
    assert_equal [@sow1, @sow2].to_json, @response.body

    get '/users/' + @user2.id.to_s + '/statements_of_work'
    assert_response :success
    assert_equal [@sow3].to_json, @response.body
  end

  #/users/:user_id/timesheets/:timesheet_id/activities
  test 'activities index' do
    get '/users/' + @user1.id.to_s + '/timesheets/' + @timesheet1.id.to_s + '/activities'
    assert_response :success
    assert_equal [@t1_act1, @t1_act2, @t1_act3].to_json, @response.body

    get '/users/' + @user1.id.to_s + '/timesheets/' + @timesheet2.id.to_s + '/activities'
    assert_response :success
    assert_equal [@t2_act1, @t2_act2].to_json, @response.body

    get '/users/' + @user2.id.to_s + '/timesheets/' + @timesheet3.id.to_s + '/activities'
    assert_response :success
    assert_equal [].to_json, @response.body
  end

  #/projects
  test 'projects index' do
    get '/projects'
    assert_response :success
    assert_equal [@project1, @project2, @project3].to_json, @response.body
  end

  #/projects/:project_id/story_cards
  test 'story cards index' do
    get '/projects/' + @project1.id.to_s + '/story_cards'
    assert_response :success
    assert_equal [].to_json, @response.body

    get '/projects/' + @project2.id.to_s + '/story_cards'
    assert_response :success
    assert_equal [@story2, @story3].to_json, @response.body

    get '/projects/' + @project3.id.to_s + '/story_cards'
    assert_response :success
    assert_equal [@story1].to_json, @response.body
  end

end
