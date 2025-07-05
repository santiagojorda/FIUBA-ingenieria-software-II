class EntradaComandoVaciaError < ArgumentError
  def initialize
    super('entrada requerida')
  end
end
