module ActivityCSV

  def to_csv
    return "%{client}%{activity}%{billable}%{weekDays}%{totals}" %
        {:client => client_columns,
         :activity => activity_string,
         :billable => billable_columns_string,
         :weekDays => self.weekday_hours_string,
         :totals => self.total_string}
  end

  def billable_columns_string
    return 'Y,Y,'
  end

  def activity_string
    return "%{name} DEV - %{code}," % {:name => self.project.name,
                                       :code => self.story_card.number}
  end

  def client_columns
    return "%{name},%{code}," % {:name => self.project.client,
                                 :code => self.project.invoice_number}
  end

  def total_string
    return "%{tots},%{tots},%{tots}" % {:tots => self.totalTime}
  end

  def weekday_hours_string
    weekdayString = ','
    myDate = self.start_time.to_datetime.new_offset(0)
    (0..5).each do |i|
      if myDate.cwday == i
        weekdayString.concat(self.totalTime)
      end
      weekdayString.concat(',')
    end
    return weekdayString
  end

end