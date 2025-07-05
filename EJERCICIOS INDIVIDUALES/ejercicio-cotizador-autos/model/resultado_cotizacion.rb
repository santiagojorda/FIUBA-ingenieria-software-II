class ResultadoCotizacion
  attr_reader :coeficiente_impositivo, :valor_mercado

  def initialize(coeficiente_impositivo, valor_mercado)
    @coeficiente_impositivo = coeficiente_impositivo
    @valor_mercado = valor_mercado
  end
end
