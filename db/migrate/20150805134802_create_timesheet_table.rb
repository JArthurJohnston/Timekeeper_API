class CreateTimesheetTable < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.datetime 'start_date'
      t.datetime 'through_date'
      t.integer 'user_id'
      t.integer 'current_activity_id'
    end
  end
end
