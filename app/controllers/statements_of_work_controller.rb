class StatementsOfWorkController < ApplicationController

  def model_class
    return StatementOfWork
  end

  def permitted_parameters
    return :number, :purchase_order_number, :client, :nickname
  end
end
