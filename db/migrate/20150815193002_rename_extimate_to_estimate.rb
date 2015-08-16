class RenameExtimateToEstimate < ActiveRecord::Migration
  def change
    rename_column :story_cards, :extimate, :estimate
  end
end
