class AddUsersToEverything < ActiveRecord::Migration
  def change
    add_column 'story_cards', 'user_id', :integer
    add_column 'activities', 'user_id', :integer
    add_column 'statements_of_work', 'user_id', :integer
  end
end
