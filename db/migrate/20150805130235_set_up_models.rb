class SetUpModels < ActiveRecord::Migration
  def change
    create_table 'activities' do |t|
      t.datetime 'start_time'
      t.datetime 'end_time'
      t.integer 'timesheet_id'
      t.integer 'story_card_id'
    end

    create_table 'projects' do |t|
      t.string 'name'
      t.integer 'statement_of_work_id'
    end

    create_table 'statements_of_work'do |t|
      t.string 'number'
      t.string 'purchase_order_number'
      t.string 'client'
      t.string 'nickname'
    end

    create_table 'story_cards' do |t|
      t.datetime 'start_date'
      t.datetime 'through_date'
      t.integer 'current_activity_id'
    end

    create_table 'users' do |t|
      t.string 'name'
    end
  end
end
