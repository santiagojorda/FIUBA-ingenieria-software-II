require_relative 'fecha_horario'

class Fecha
  include Comparable

  attr_reader :fecha

  FORMATO = '%d/%m/%Y'.freeze

  def initialize(fecha_data)
    case fecha_data
    when String
      @fecha = Date.strptime(fecha_data, FORMATO)
    when Date
      @fecha = fecha_data
    when DateTime, FechaHorario
      @fecha = fecha_data.to_date
    else
      raise ArgumentError, 'Formato inválido para fecha'
    end
  end

  def to_s
    @fecha.strftime(FORMATO)
  end

  def to_date
    @fecha
  end

  def <=>(other)
    return nil unless other.is_a?(Fecha)

    fecha <=> other.fecha
  end

  def es_fin_de_semana?
    fecha.saturday? || fecha.sunday?
  end

  def anio
    fecha.year
  end

  def mes
    fecha.month
  end

  def dia
    fecha.day
  end

  def +(other)
    raise ArgumentError, 'Se espera un número entero' unless other.is_a?(Integer)

    Fecha.new(fecha + other)
  end

  def -(other)
    raise ArgumentError, 'Se espera un número entero' unless other.is_a?(Integer)

    Fecha.new(fecha - other)
  end
end
