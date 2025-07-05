require_relative 'vehiculo'

class Camioneta < Vehiculo
  PRECIO_BASE = 1500

  def initialize(cilindrada, kilometros)
    super(PRECIO_BASE, cilindrada, kilometros)
  end

  def valor_mercado
    (3 * coeficiente_impositivo * precio_base / ((kilometros + cilindrada) * 0.003)).truncate(1)
  end
end
