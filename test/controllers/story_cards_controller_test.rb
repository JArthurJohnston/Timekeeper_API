require 'test_helper'

class StoryCardsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'model class' do
    assert_equal StoryCard, @controller.model_class
  end

  test 'permitted parameters' do
    assert_equal [:project_id, :number, :title, :description, :estimate], @controller.permitted_parameters
  end

  test 'create parameters' do
    assert_equal [:project_id, :number, :title, :description, :estimate], @controller.create_parameters
  end

  test 'required parameter' do
    assert_equal :story_card, @controller.required_parameter
  end

end
