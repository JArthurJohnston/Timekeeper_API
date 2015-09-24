class StoryCard < ActiveRecord::Base
  belongs_to :project
  has_many :activities, -> {order(:start_time)}

  def billable_hours
    billable_hours = 0.0
    self.activities.each do
      |eachActivity|
      unless eachActivity.totalTime.eql? Float::INFINITY
        billable_hours += eachActivity.totalTime
      end
    end
    return billable_hours
  end

end
