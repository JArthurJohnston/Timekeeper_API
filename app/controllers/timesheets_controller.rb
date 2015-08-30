require_relative '../../app/models/modules/date_time_helper'

class TimesheetsController < ApplicationController
  include DateTimeHelper

  def create
    params[:start_date] = date_from_attribute params[:start_date]
    params[:through_date] = date_from_attribute params[:through_date]
    super
  end

  def model_class
    return Timesheet
  end

  def permitted_parameters
    return :start_Date, :through_date, :current_activity_id
  end

  def create_parameters
    return permitted_parameters
  end

  def find_all params
    return find_by_user params
  end

end
