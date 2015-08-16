require_relative 'model_test_case'

class UserTest < ModelTestCase

  test 'user name' do
    expected_name = 'bob loblaw'
    user = User.create(name: expected_name)

    assert_equal expected_name, user.name
  end

  test 'user has timehseets, statements of work and activities' do
    user = User.create
    assert_empty user.statements_of_work
    assert_empty user.timesheets
    assert_empty user.activities

    sow = StatementOfWork.create(user_id: user.id)
    timesheet = Timesheet.create(user_id: user.id)
    activity = Activity.create(user_id: user.id)

    assert_equal 1, user.statements_of_work.size
    assert_equal 1, user.timesheets.size
    assert_equal 1, user.activities.size

    assert user.statements_of_work.include? sow
    assert user.timesheets.include? timesheet
    assert user.activities.include? activity
  end

end
