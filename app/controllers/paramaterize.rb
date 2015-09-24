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

  def parse_parameter_dates *date_symbols
    # dates_from_strings = []
    date_symbols.each do
      |each_symbol|
      date = DateTime.parse(params[each_symbol])
      # dates_from_strings.push(each_symbol => date)
      params[each_symbol]= date
    end
  end

end