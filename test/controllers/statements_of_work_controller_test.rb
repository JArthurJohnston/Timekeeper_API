require 'test_helper'

class StatementsOfWorkControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'model class' do
    assert_equal StatementOfWork, @controller.model_class
  end

  test 'permitted parameters' do
    assert_equal [:number, :purchase_order_number, :client], @controller.permitted_parameters
  end

  test 'required parameter' do
    assert_equal :statement_of_work, @controller.required_parameter
  end

  test 'create parameters' do
    assert_equal [:number, :purchase_order_number, :client, :user_id], @controller.create_parameters
  end
end
