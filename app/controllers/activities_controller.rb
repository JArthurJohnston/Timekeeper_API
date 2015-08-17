class ActivitiesController < ApplicationController

  def model_class
    return Activity
  end

  def find_all params
    return Activity.where(user_id: params[:user_id])
  end

end
