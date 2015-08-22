class StatementsOfWorkController < ApplicationController

  def model_class
    return StatementOfWork
  end

  def permitted_parameters
    return :number, :purchase_order_number, :client
  end

  def required_parameter
    return :statement_of_work
  end

  def create_parameters
    return permitted_parameters.push(:user_id)
  end

end
