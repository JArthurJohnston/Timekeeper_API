module AttributeHandler

  def getAttribute id_symbol, aModelClass
    unless self.send(id_symbol).nil?
      return aModelClass.find(self.send(id_symbol))
    end
    return nil
  end

  def setAttribute id_symbol, a_foreign_key
    setter_symbol = id_symbol.to_s.concat('=')
    self.send setter_symbol, a_foreign_key
    self.save
  end
end