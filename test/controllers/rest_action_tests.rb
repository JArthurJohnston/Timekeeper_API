module RestActionTests

  def model_class
    return @controller.model_class
  end

  def test_index_action
    mod1 = model_class.create
    mod2 = model_class.create
    get :index

    assert_response :success
    assert_equal [mod1, mod2].to_json, @response.body
  end

  def test_create_action

  end

  def test_read_action

  end

  def test_update_action

  end

  def test_destroy_action

  end

end