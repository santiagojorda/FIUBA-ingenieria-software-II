require 'faraday'
require 'json'
require_relative './proveedor_feriados_base'

class ProveedorFeriadosMock < ProveedorFeriadosBase
  def initialize(fechas_feriados = [])
    super()
    fechas_feriados.each do |fecha|
      @feriados << Fecha.new(fecha)
    end
  end
end
