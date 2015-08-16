class FixStoryCards < ActiveRecord::Migration
  def change
    remove_column :story_cards, :start_date
    remove_column :story_cards, :through_date
    remove_column :story_cards, :current_activity_id

    add_column :story_cards, :project_id, :string
    add_column :story_cards, :number, :string
    add_column :story_cards, :title, :string
    add_column :story_cards, :description, :string
    add_column :story_cards, :extimate, :integer
  end
end
