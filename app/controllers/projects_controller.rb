class ProjectsController < ApplicationController

  def model_class
    return Project
  end

  def create_parameters
    return permitted_parameters
  end

  def permitted_parameters
    return :name, :statement_of_work_id
  end

end
