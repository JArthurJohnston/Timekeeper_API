class ProjectsController < ApplicationController

  def model_class
    return Project
  end

  def permitted_parameters
    return :name, :statement_of_work_id
  end

end
