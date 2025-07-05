require_relative './proveedor_feriados_base'
require_relative '../../utilidades/fecha'
require_relative '../../utilidades/fecha_horario'

class DataProviderError < StandardError; end

class ProveedorFeriadosBase
  attr_reader :feriados

  def initialize
    @feriados = []
  end

  def es_feriado?(fecha_a_verificar)
    raise ArgumentError, "Se esperaba un objeto de tipo Fecha, se recibió #{fecha_a_verificar.class}" unless fecha_a_verificar.is_a?(Fecha)

    @feriados.include?(fecha_a_verificar)
  end
end
