class StoryCardLineItem
  attr_reader :story_card,
              :timesheet

  def initialize(aStoryCard, aTimesheet)
    @project = aStoryCard.project
    @story_card = aStoryCard
    @timesheet = aTimesheet
  end

  def billable_hours
    hours = 0.0
    activity_line_items.each do |each_line_item|
      hours += each_line_item.billable_hours
    end
    return hours
  end

  def to_csv
    return "%{client}%{activity}%{billable}%{weekDays}%{totals}" %
        {:client => client_columns,
         :activity => activity_string,
         :billable => billable_columns_string,
         :weekDays => weekday_hours_string,
         :totals => total_string}
  end

  private

  def activity_line_items
    items = []
    @timesheet.days.each do
    |e|
      items.push(ActivityLineItem.new(e, @story_card))
    end
    return items
  end

  def billable_columns_string
    return 'Y,Y,'
  end

  def activity_string
    return "%{name} DEV - %{code}," % {:name => @project.name,
                                       :code => @story_card.number}
  end

  def client_columns
    return "%{name},%{code}," % {:name => @project.client,
                                 :code => @project.invoiceNumber}
  end

  def total_string
    return "%{tots},%{tots},%{tots}" % {:tots => self.billable_hours}
  end

  def weekday_hours_string
    weekdayString = ','
    activities = activity_line_items
    for i in 0..5 do
      activities.each do |each_line_item|
        if each_line_item.date.cwday == i
          if each_line_item.billable_hours > 0.0
            weekdayString.concat(each_line_item.billable_hours)
          end
        end
      end
      weekdayString.concat(',')
    end
    return weekdayString
  end

end