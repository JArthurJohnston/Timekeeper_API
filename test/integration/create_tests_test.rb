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
    new_sow_json = '{"number":"222", "purchase_order_number":"345", "client":"Harold"}'

    assert_nil StatementOfWork.find_by(user_id: @user1.id, number: "222", purchase_order_number: "345", client: "Harold")
    assert_equal 3, StatementOfWork.all.size

    post '/users/1/statements_of_work', new_sow_json, json_header

    assert_response :success
    assert_equal 4, StatementOfWork.all.size
    assert_not_nil StatementOfWork.find_by(user_id: @user1.id, number: "222", purchase_order_number: "345", client: "Harold")
  end

  #/users/:user_id/timesheets/:timesheet_id/activities
  test 'create activities' do

  end

end
