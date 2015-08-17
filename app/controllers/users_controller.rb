class UsersController < ApplicationController

  def model_class
    return User
  end

  def permitted_parameters
    return :name
  end

end
