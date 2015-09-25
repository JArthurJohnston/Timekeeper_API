require 'test_helper'
require_relative 'setup_integration_models'
require_relative '../../config/initializers/core_extensions/date_time/time_rounding'

class IntegrationTestCase < ActionDispatch::IntegrationTest
  include SetupIntegrationModels

  def setup
    setup_models
  end

  def teardown
    StoryCard.delete_all
    Timesheet.delete_all
    Project.delete_all
    Activity.delete_all
    StatementOfWork.delete_all
    User.delete_all
  end
end