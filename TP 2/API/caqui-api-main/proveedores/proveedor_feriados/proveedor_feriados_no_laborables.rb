require 'faraday'
require 'json'
require_relative './proveedor_feriados_base'

class ProveedorFeriadosNoLaborables < ProveedorFeriadosBase
  URL_API = 'https://nolaborables.com.ar/api/v2/feriados'.freeze

  def initialize(anio)
    super()
    buscar_feriados_por_anio(anio)
  end

  private

  def buscar_feriados_por_anio(anio)
    api_url_anio = "#{URL_API}/#{anio}"

    response = Faraday.get(api_url_anio)

    raise DataProviderError, 'Hubo un error en la api de feriados' unless response.success?

    feriados_data = JSON.parse(response.body)
    @feriados = feriados_data.map do |feriado|
      Fecha.new("#{feriado['dia']}/#{feriado['mes']}/#{anio}")
    end
  end
end
