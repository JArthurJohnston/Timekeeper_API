require_relative '../../app/models/modules/common_story_cards'

class Project < ActiveRecord::Base
  has_many :story_cards
  belongs_to :statement_of_work
  include CommonStoryCards

  def indexDisplayString
    "%{name} : %{sow} : %{invoiceId}" % {:name => self.name,
                                         :sow => self.statementOfWork,
                                         :invoiceId => self.invoiceNumber}
  end


  def invoice_number
    return self.statement_of_work.number
  end

  def client
    return self.statement_of_work.client
  end

end
