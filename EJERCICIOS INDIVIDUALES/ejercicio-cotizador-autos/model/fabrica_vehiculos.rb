require_relative './excepciones/tipo_vehiculo_invalido_error'
require_relative './auto'
require_relative './camioneta'
require_relative './camion'

class FabricaVehiculos
  def crear_vehiculo(tipo, cilindrada, kilometros)
    case tipo
    when 'auto' then Auto.new(cilindrada, kilometros)
    when 'camioneta' then Camioneta.new(cilindrada, kilometros)
    when 'camion' then Camion.new(cilindrada, kilometros)
    else raise TipoDeVehiculoInvalidoError
    end
  end
end
