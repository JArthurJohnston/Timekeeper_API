class RemoveUsersFromStoryCards < ActiveRecord::Migration
  def change
    remove_column :story_cards, :user_id
  end
end
