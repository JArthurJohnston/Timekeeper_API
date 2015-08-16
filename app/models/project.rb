class Project < ActiveRecord::Base
  has_many :story_cards
  belongs_to :statement_of_work

  def purchase_order_number
    return self.statement_of_work.purchase_order_number
  end

  def invoice_number
    return self.statement_of_work.number
  end

  def client
    return self.statement_of_work.client
  end

end
