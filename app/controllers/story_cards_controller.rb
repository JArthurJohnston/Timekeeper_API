class StoryCardsController < ApplicationController

  def model_class
    return StoryCard
  end

  def permitted_parameters
    return :project_id, :number, :title, :description, :estimate
  end

  def required_parameter
    :story_card
  end

  def create_parameters
    return permitted_parameters
  end

  def find_all params
    return StoryCard.where(project_id: params[:project_id])
  end
end
