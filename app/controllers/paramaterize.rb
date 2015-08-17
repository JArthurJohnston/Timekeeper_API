module Paramaterize

  def required_parameter
    return self.model_class.name.downcase.to_sym
  end

  def permitted_parameters
    raise 'mixin responsibility'
  end

  def model_parameters
    return ActionController::Parameters.new(JSON.parse(params.require(:user))).permit(permitted_parameters)
  end

end