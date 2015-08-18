require 'test_helper'
require_relative 'setup_integration_models'

class UrlResponsesTest < ActionDispatch::IntegrationTest
  include SetupIntegrationModels

  def setup
    setup_models
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
