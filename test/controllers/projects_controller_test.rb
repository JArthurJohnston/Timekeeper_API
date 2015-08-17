require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'model class' do
    assert_equal Project, @controller.model_class
  end

  test 'permitted parameters' do
    assert_equal [:name, :statement_of_work_id], @controller.permitted_parameters
  end

end
