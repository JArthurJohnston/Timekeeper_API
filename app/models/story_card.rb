class StoryCard < ActiveRecord::Base
  belongs_to :project
  has_many :activities

  def projectNumber
    return "%{projectName} : %{cardNumber}" % {:projectName => self.project.name, :cardNumber => self.number}
  end

  def indexDisplayString
    return "%{projectNumber} : %{title} : %{estimate}" % {:projectNumber => self.projectNumber,
                                                                :estimate => self.estimateString,
                                                                :title => self.title}
  end

  def estimateString
    if self.estimate.nil?
      return 'Not yet estimated'
    end
    self.estimate
  end

  def billableHours
    billable_hours = 0.0
    self.activities.each do
      |eachActivity|
      unless eachActivity.totalTime.eql? Float::INFINITY
        billable_hours += eachActivity.totalTime
      end
    end
    return billable_hours
  end

  def can_be_deleted
    return self.activities.empty?
  end

end
