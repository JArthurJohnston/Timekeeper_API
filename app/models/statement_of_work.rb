class StatementOfWork < ActiveRecord::Base
  has_many :projects
  belongs_to :user

  def display_name
    return "%{number} : %{client} : %{nickname}" % {:number => self.number,
                                                    :client => self.client,
                                                    :nickname => self.nickname}
  end

  def indexDisplayString
    return display_name
  end

end
