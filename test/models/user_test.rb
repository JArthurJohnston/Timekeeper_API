require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: 'ME', email: 'me@mine.com', password:'totallySecure',
              password: 'foobar', password_confirmation: 'foobar')
  end

  test 'User is valid' do
    assert @user.valid?
  end

  test 'fields are required' do
    @user.name= '  '
    assert_not @user.valid?
    @user.name = 'ImValidAgain!'
    assert @user.valid?

    @user.password= '  '
    assert_not @user.valid?
    @user.password= 'foobar'
    assert @user.valid?

    @user.email= '  '
    assert_not @user.valid?
    @user.email= 'ImValidAgain@somethign.com'
    assert @user.valid?
  end

  test 'checks email validity' do
    @user.email = '@something.com'
    assert_not @user.valid?

    @user.email = 'mike.com'
    assert_not @user.valid?

    @user.email = 'mike@smith.com'
    assert @user.valid?
  end

  test 'passwords should be valid' do
    passwordIsValid '12345', false
    passwordIsValid '        ', false
    passwordIsValid 'moreThanSixCharacters', true
  end

  def passwordIsValid testPassword, validity
    @user.password_confirmation= testPassword
    @user.password= testPassword
    assert_equal validity, @user.valid?
  end

  # test 'email should be unique' do
  #   emailThatShouldBeUnique = 'some@email.unique.com'
  #   @user.email= emailThatShouldBeUnique
  #   assert @user.valid?
  #
  #   someOtherUser = @user.dup
  #   someOtherUser.email= emailThatShouldBeUnique
  #   someOtherUser.save
  #   assert_not someOtherUser.valid?, 'this user shouldnt be valid'
  #
  #   someOtherUser = User.new(name: 'ME', email: emailThatShouldBeUnique.upcase, password:'totallySecure')
  #   someOtherUser.save
  #   assert_not someOtherUser.valid?, 'uppercase emial: this user shouldnt be valid'
  # end

end
