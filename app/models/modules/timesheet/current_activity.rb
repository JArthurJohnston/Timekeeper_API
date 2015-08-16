module CurrentActivity

  def current_activity
    return Activity.find_by(id: self.current_activity_id)
  end

  def current_project
    currentActivity = self.current_activity
    unless currentActivity.nil?
      return currentActivity.project
    end
  end

  def current_story_card
    currentActivity = self.current_activity
    unless currentActivity.nil?
      return currentActivity.story_card
    end
  end

end