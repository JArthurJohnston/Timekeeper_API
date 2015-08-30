class ActivitiesController < ApplicationController

  def model_class
    return Activity
  end

  def find_all params
    return Activity.where(timesheet_id: params[:timesheet_id], user_id: params[:user_id])
  end

  def create_parameters
    return permitted_parameters
  end

  def permitted_parameters
    return :start_time, :end_time, :timesheet_id, :story_card_id, :user_id
  end

end
