class RemoveDatesFromTimesheet < ActiveRecord::Migration
  def change
    remove_column :timesheets, :start_date
  end
end
