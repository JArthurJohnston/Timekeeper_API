require_relative '../../app/models/modules/common_story_cards'

class Project < ActiveRecord::Base
  has_many :story_cards
  has_one :statement_of_work
  include CommonStoryCards

  def indexDisplayString
    "%{name} : %{sow} : %{invoiceId}" % {:name => self.name,
                                         :sow => self.statementOfWork,
                                         :invoiceId => self.invoiceNumber}
  end


end
