require_relative '../../app/models/modules/date_time_helper'

class TimesheetsController < ApplicationController
  include DateTimeHelper

  def model_class
    return Timesheet
  end

  def permitted_parameters
    return :current_activity_id, :user_id
  end

  def create_parameters
    return permitted_parameters
  end

  def find_all
    return find_by_user
  end

end
