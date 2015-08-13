class User < ActiveRecord::Base
  has_many :timesheets
  has_many :activities

end
