require 'test_helper'
require_relative 'setup_integration_models'

class UpdateTestsTest < ActionDispatch::IntegrationTest
  include SetupIntegrationModels
  # test "the truth" do
  #   assert true
  # end

  def setup
    setup_models
  end

  #/users/:user_id/statements_of_work/:id
  test 'update SOWs' do
    new_sow_json = '{"number":"4444", "purchase_order_number":"A66", "client":"Harold"}'
    uri = '/users/' + @user1.id.to_s + '/statements_of_work/' + @sow1.id.to_s

    patch uri, new_sow_json, json_header
    #could also use PUT

    assert_response :success

    updated_sow = StatementOfWork.find(@sow1.id)

    assert_equal '4444', updated_sow.number
    assert_equal 'A66', updated_sow.purchase_order_number
    assert_equal 'Harold', updated_sow.client
  end
end
