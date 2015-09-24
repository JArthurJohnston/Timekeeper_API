class UsersController < ApplicationController

  def model_class
    return User
  end

  def permitted_parameters
    return :name
  end

  def create_parameters
    return permitted_parameters
  end

end
