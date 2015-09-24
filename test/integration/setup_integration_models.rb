module SetupIntegrationModels

  def setup_models
    @user1 = User.create(name: 'John Doe')
    @user2 = User.create(name: 'Jane Doe')
    @all_users = [@user1, @user2]

    setup_first_timesheet_and_activities
    setup_second_timesheet_and_activities
    @timesheet3 = Timesheet.create(start_date: DateTime.new(2015, 1,1), user_id: @user2.id)

    @sow1 = StatementOfWork.create(user_id: @user1.id, number: 'SOW013', purchase_order_number: 'A123', client: 'Mickey')
    @sow2 = StatementOfWork.create(user_id: @user1.id, number: 'SOW014', purchase_order_number: 'B456', client: 'Donald')
    @sow3 = StatementOfWork.create(user_id: @user2.id, number: 'SOW001', purchase_order_number: 'C789', client: 'Goofy')

    @project1 = Project.create(name: 'Disneyland', statement_of_work_id: @sow1.id)
    @project2 = Project.create(name: 'Disneyworld', statement_of_work_id: @sow2.id)
    @project3 = Project.create(name: 'Euro Disney', statement_of_work_id: @sow2.id)

    @story1 = StoryCard.create(project_id: @project3.id, number: '123', title: 'Make it stop raining', description: 'it rains too much. make it stop', estimate: 32)
    @story2 = StoryCard.create(project_id: @project2.id, number: '001', title: 'Make it smell nice', description: 'we need people to buy food', estimate: 8)
    @story3 = StoryCard.create(project_id: @project2.id, number: '002', title: 'Its a small world', description: 'after all', estimate: 4)
  end

  def json_header
    return {'Content-Type' => 'application/json'}
  end

  private

    def setup_first_timesheet_and_activities
      @timesheet1 = Timesheet.create(start_date: DateTime.new(2015, 1,1), user_id: @user1.id)

      @t1_act1 = Activity.create(timesheet_id: @timesheet1.id, start_time: DateTime.new(2015,1,1,5,15,0), end_time: DateTime.new(2015,1,1,7,30,0), user_id: @user1.id)
      @t1_act2 = Activity.create(timesheet_id: @timesheet1.id, start_time: DateTime.new(2015,1,1,8,15,0), end_time: DateTime.new(2015,1,1,9,0,0), user_id: @user1.id)
      @t1_act3 = Activity.create(timesheet_id: @timesheet1.id, start_time: DateTime.new(2015,1,1,6,45,0), end_time: DateTime.new(2015,1,3,12,0,0), user_id: @user1.id)
    end

    def setup_second_timesheet_and_activities
      @timesheet2 = Timesheet.create(start_date: DateTime.new(2015, 1,1), user_id: @user1.id)

      @t2_act1 = Activity.create(timesheet_id: @timesheet2.id, start_time: DateTime.new(2015,1,3,5,15,0), end_time: DateTime.new(2015,1,3,7,30,0))
      @t2_act2 = Activity.create(timesheet_id: @timesheet2.id, start_time: DateTime.new(2015,1,3,6,45,0), end_time: DateTime.new(2015,1,3,12,0,0))
    end

end