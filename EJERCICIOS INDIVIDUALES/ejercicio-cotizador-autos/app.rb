require_relative './model/cotizador'
require_relative './model/excepciones/entrada_comando_vacia_error'
require_relative './model/excepciones/formato_invalido_comando_cotizacion_error'

entrada = ARGV[0]

begin
  raise EntradaComandoVaciaError unless entrada

  params = entrada.split('/')
  raise FOrmatoInvalidoComandoCotizacionError if params.length != 3

  tipo = params[0]
  cilindrada = params[1].to_i
  kilometros = params[2].to_i

  resultado = Cotizador.new.cotizar(tipo, cilindrada, kilometros)
  puts "ci:#{resultado.coeficiente_impositivo} & vm:#{resultado.valor_mercado}"
rescue ArgumentError => e
  puts "error: #{e.message}"
  exit 1
rescue StandardError => e
  puts "error inesperado: #{e.message}"
  exit 1
end
