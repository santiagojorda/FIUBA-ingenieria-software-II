require_relative './fabrica_vehiculos'
require_relative './resultado_cotizacion'

class Cotizador
  def initialize
    @fabrica = FabricaVehiculos.new
  end

  def cotizar(vehiculo, cilindrada, kilometros)
    vehiculo = @fabrica.crear_vehiculo(vehiculo, cilindrada, kilometros)
    ResultadoCotizacion.new(vehiculo.coeficiente_impositivo, vehiculo.valor_mercado)
  end
end
