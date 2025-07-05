require_relative 'fecha'

class FechaHorario
  FORMATO = '%d/%m/%Y %H:%M'.freeze
  TARGET_OFFSET = '-03:00'.freeze
  def initialize(fecha_hora)
    @fecha_hora = parsear_fecha(fecha_hora)
  end

  def to_s
    @fecha_hora.strftime(FORMATO)
  end

  def <=>(other)
    return nil unless other.is_a?(FechaHorario)

    to_datetime <=> other.to_datetime
  end

  def anio
    to_fecha.anio
  end

  def mes
    to_fecha.mes
  end

  def dia
    to_fecha.dia
  end

  def es_fin_de_semana?
    to_fecha.es_fin_de_semana?
  end

  def to_fecha
    Fecha.new(@fecha_hora.to_date)
  end

  def to_date
    @fecha_hora.to_date
  end

  def to_datetime
    @fecha_hora
  end

  def to_time
    @fecha_hora.to_time
  end

  def +(other)
    raise ArgumentError, 'Se espera un número (entero o decimal)' unless other.is_a?(Integer) || other.is_a?(Float)

    FechaHorario.new(@fecha_hora + other.to_f / 24)
  end

  def -(other)
    raise ArgumentError, 'Se espera un número entero' unless other.is_a?(Integer)

    FechaHorario.new(@fecha_hora - other.to_f / 24)
  end

  def diferencia_en_horas(otro)
    raise ArgumentError, 'Se espera un FechaHorario' unless otro.is_a?(FechaHorario)

    (otro.to_datetime - to_datetime).to_f * 24
  end

  def ==(other)
    other.is_a?(FechaHorario) && @fecha_hora == other.to_datetime
  end

  def >(other)
    other.is_a?(FechaHorario) && @fecha_hora > other.to_datetime
  end

  def <(other)
    other.is_a?(FechaHorario) && @fecha_hora < other.to_datetime
  end

  def >=(other)
    other.is_a?(FechaHorario) && @fecha_hora >= other.to_datetime
  end

  def <=(other)
    other.is_a?(FechaHorario) && @fecha_hora <= other.to_datetime
  end

  private

  def parsear_fecha(fecha_hora)
    case fecha_hora
    when String
      datetime_sin_offset = DateTime.strptime(fecha_hora, FORMATO)
      parsear_datetime(datetime_sin_offset)
    when Time
      parsear_datetime(fecha_hora.to_datetime)
    when DateTime
      parsear_datetime(fecha_hora)
    else
      raise ArgumentError, "Formato inválido para fecha_hora: #{fecha_hora.class}"
    end
  end

  def parsear_datetime(datetime)
    DateTime.new(datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min, 0, TARGET_OFFSET)
  end
end
