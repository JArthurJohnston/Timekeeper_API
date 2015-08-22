module Paramaterize

  def required_parameter
    return self.model_class.name.parameterize.to_sym
  end

  def permitted_parameters
    raise 'mixin responsibility'
  end

  def model_parameters
    return using_parameters(permitted_parameters)
  end

  def using_parameters param_symbols
    return params.require(required_parameter).permit(param_symbols)
  end

end