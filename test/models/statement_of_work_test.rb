require 'test_helper'

class StatementOfWorkTest < ActiveSupport::TestCase

  test 'sow has projects' do
    sow = StatementOfWork.create

    assert_empty sow.projects

    project1 = Project.create(statement_of_work_id: sow.id)
    project2 = Project.create(statement_of_work_id: sow.id)

    sow_projects = sow.projects
    assert_equal 2, sow_projects.length
    assert sow_projects.include?(project1)
    assert sow_projects.include?(project2)
  end

  test 'sow fields' do
    sow_number = 'SOW03'
    po_number = 'SUBSOW3344'
    client_name = 'Acme Co'
    nickname = 'the name of nick'
    sow = StatementOfWork.create(number: sow_number, purchase_order_number: po_number, client: client_name, nickname: nickname)

    assert_equal sow_number, sow.number
    assert_equal po_number, sow.purchase_order_number
    assert_equal client_name, sow.client
    assert_equal nickname, sow.nickname
  end

  test 'display name' do
    sow = StatementOfWork.create(nickname: 'Steve', client: 'Jobs', number: 'SOW55')
    assert_equal 'SOW55 : Jobs : Steve', sow.display_name
  end
end