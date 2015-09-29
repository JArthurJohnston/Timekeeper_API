class ChangeStoryCardProjectIdToInteger < ActiveRecord::Migration
  def change
    change_column :story_cards, :project_id, :integer
  end
end
