class StatementOfWork < ActiveRecord::Base
  has_many :projects, -> {order(:name)}
  belongs_to :user
end
