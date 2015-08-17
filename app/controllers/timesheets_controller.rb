class TimesheetsController < ApplicationController

  def model_class
    return Timesheet
  end

  def permitted_parameters
    return :start_Date, :through_date, :current_activity_id
  end

  def find_all params
    return find_by_user params
  end

end
