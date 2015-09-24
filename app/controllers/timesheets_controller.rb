require_relative '../../app/models/modules/date_time_helper'

class TimesheetsController < ApplicationController
  include DateTimeHelper

  def create
    cache_params
    parse_parameter_dates :start_date, :through_date
    super
  end

  def model_class
    return Timesheet
  end

  def permitted_parameters
    return :start_date, :through_date, :current_activity_id, :user_id
  end

  def create_parameters
    return permitted_parameters
  end

  def find_all
    return find_by_user
  end

end
