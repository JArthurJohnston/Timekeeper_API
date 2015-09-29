class RemoveThroughDateFromTimesheet < ActiveRecord::Migration
  def change
    remove_column :timesheets, :through_date
  end
end
