require_relative 'excepciones/cilindrada_invalida_error'

class Vehiculo
  attr_reader :cilindrada, :kilometros, :precio_base

  CILINDRADAS_VALIDAS = [1000, 1600, 2000].freeze

  def initialize(precio_base, cilindrada, kilometros)
    validar_cilindrada(cilindrada)

    @precio_base = precio_base
    @cilindrada = cilindrada
    @kilometros = kilometros
  end

  def coeficiente_impositivo
    (precio_base * cilindrada / 1_000_000).to_i
  end

  def valor_mercado
    raise NotImplementedError
  end

  private

  def validar_cilindrada(cilindrada)
    return if CILINDRADAS_VALIDAS.include?(cilindrada)

    raise CilindradaInvalidaError
  end
end
