require_relative 'vehiculo'

class Camion < Vehiculo
  PRECIO_BASE = 2000

  def initialize(cilindrada, kilometros)
    super(PRECIO_BASE, cilindrada, kilometros)
  end

  def valor_mercado
    (coeficiente_impositivo * precio_base / ((kilometros + cilindrada) * 0.002)).truncate(1)
  end
end
