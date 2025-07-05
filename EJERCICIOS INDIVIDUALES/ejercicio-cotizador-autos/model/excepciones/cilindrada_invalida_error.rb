class CilindradaInvalidaError < ArgumentError
  def initialize
    super("Tipo de cilindrada invalida [#{Vehiculo::CILINDRADAS_VALIDAS.join(', ')}]")
  end
end
