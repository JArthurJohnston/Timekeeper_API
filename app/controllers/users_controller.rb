class UsersController < ApplicationController

  def model_class
    return User
  end

  def model_params
    user_params = ActionController::Parameters.new(JSON.parse(params.require(:user)))
    return user_params.permit(:name)
  end

end
