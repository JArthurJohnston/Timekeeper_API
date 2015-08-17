require 'test_helper'

class TimesheetsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'model class' do
    assert_equal Timesheet, @controller.model_class
  end

  test 'permitted parameters' do
    assert_equal [:start_Date, :through_date, :current_activity_id], @controller.permitted_parameters
  end

end
