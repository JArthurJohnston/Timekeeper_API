require 'test_helper'

class TimesheetsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'model class' do
    assert_equal Timesheet, @controller.model_class
  end

  test 'permitted parameters' do
    assert_equal [:start_date, :through_date, :current_activity_id, :user_id], @controller.permitted_parameters
  end

end
