require_relative 'vehiculo'

class Auto < Vehiculo
  PRECIO_BASE = 1000

  def initialize(cilindrada, kilometros)
    super(PRECIO_BASE, cilindrada, kilometros)
  end

  def valor_mercado
    (coeficiente_impositivo * PRECIO_BASE / (1 + 0.001 * kilometros)).truncate(1)
  end
end
