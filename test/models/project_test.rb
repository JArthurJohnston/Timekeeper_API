require_relative 'model_test_case'

class ProjectTest < ModelTestCase

  def setup
    client = 'Pettersons'
    name = 'Carmichael'
    invoiceNumber = 'P2342'
    sow = 'SOW88'
    @project = Project.new(name: name, invoiceNumber: invoiceNumber, client: client, statementOfWork: sow)
  end

  test 'project has fields' do
    client = 'Pettersons'
    name = 'Carmichael'
    invoiceNumber = 'P2342'
    sow = 'SOW88'
    project = Project.new(name: name, invoiceNumber: invoiceNumber, client: client, statementOfWork: sow)

    assert_equal client, project.client
    assert_equal name, project.name
    assert_equal invoiceNumber, project.invoiceNumber
    assert_equal sow, project.statementOfWork
  end

  test 'project has story cards' do
    project = Project.new(name: '', invoiceNumber: '', client: '')
    project.save

    assert_empty project.story_cards

    storyCard1 = StoryCard.new(number:'1',title: '', description: '', project_id: project.id)
    storyCard1.save
    storyCard2 = StoryCard.new(number:'2',title: '', description: '', project_id: project.id)
    storyCard2.save

    assert_equal 2, project.story_cards.size
    assert project.story_cards.include? storyCard1
    assert project.story_cards.include? storyCard2
  end

  test 'story card created with project' do
    project = Project.create()
    storyCard = StoryCard.create(project: project)

    assert_equal project.id, storyCard.project_id
    assert_equal project, storyCard.project
    assert project.story_cards.include? storyCard
  end

  test 'index display string' do
    assert_equal 'Carmichael : SOW88 : P2342', @project.indexDisplayString
  end

  test 'initialize story cards' do
    project = Project.create

    project.initialize_common_cards

    assert_equal 6, project.story_cards.size
  end

  test 'doesnt add common card that already exists' do
    project = Project.create
    StoryCard.create(number: 'KIK', project_id: project.id)
    project.initialize_common_cards

    assert_equal 6, project.story_cards.size
  end

  test 'destroying a project destroys all its story cards' do
    fail 'write me!!!'
  end

  test 'project has statement of work' do
    sow = StatementOfWork.create
    project = Project.create(statement_of_work_id: sow.id)

    assert_equal sow.id, project.statement_of_work_id
    assert_equal sow, project.statement_of_work
  end

  test 'gets stuff from statement of work' do
    fail('write me!!!!')
  end

end
