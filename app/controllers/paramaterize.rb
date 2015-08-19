module Paramaterize

  def required_parameter
    return self.model_class.name.parameterize.to_sym
  end

  def permitted_parameters
    raise 'mixin responsibility'
  end

  def model_parameters
    return params.require(required_parameter).permit(permitted_parameters)
  end

end