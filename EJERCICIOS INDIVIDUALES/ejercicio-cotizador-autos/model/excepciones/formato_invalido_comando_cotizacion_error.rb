class FOrmatoInvalidoComandoCotizacionError < ArgumentError
  def initialize
    super('formato de entrada invalido: <tipo>/<cilindrada>/<kilometros>')
  end
end
