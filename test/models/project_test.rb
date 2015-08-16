require_relative 'model_test_case'

class ProjectTest < ModelTestCase

  test 'project has story cards' do
    project = Project.create()

    assert_empty project.story_cards

    storyCard1 = StoryCard.create(number:'1',title: '', description: '', project_id: project.id)
    storyCard2 = StoryCard.create(number:'2',title: '', description: '', project_id: project.id)

    assert_equal 2, project.story_cards.size
    assert project.story_cards.include? storyCard1
    assert project.story_cards.include? storyCard2
  end

  test 'project fields' do
    expected_sow_number = 'GT123'
    expected_PO_number = 'HY345'
    expected_client = 'Mickey'
    expected_project_name = 'Mouse'
    sow = StatementOfWork.create(number: expected_sow_number, purchase_order_number: expected_PO_number, client: expected_client)
    project = Project.create(statement_of_work_id: sow.id, name: expected_project_name)

    assert_equal expected_sow_number, project.invoice_number
    assert_equal expected_client, project.client
    assert_equal expected_PO_number, project.purchase_order_number
    assert_equal sow, project.statement_of_work
    assert_equal expected_project_name, project.name
  end

end
