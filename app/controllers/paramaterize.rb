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
    parse_dates_on_params params, date_symbols
  end

  def parse_dates_on_params params_hash, *date_symbols
    date_symbols.each do
    |each_symbol|
      date_string = params_hash[each_symbol]
      date = DateTime.parse(date_string)
      params_hash[each_symbol]= date
    end
  end

end