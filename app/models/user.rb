class User < ActiveRecord::Base
  has_many :timesheets
  has_many :activities
  has_many :statements_of_work

end
