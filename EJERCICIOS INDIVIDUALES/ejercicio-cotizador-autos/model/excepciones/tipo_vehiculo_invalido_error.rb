class TipoDeVehiculoInvalidoError < ArgumentError
  def initialize
    super('Tipo de vehiculo invalido')
  end
end
