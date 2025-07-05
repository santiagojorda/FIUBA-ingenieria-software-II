require_relative 'estado_turno'
require_relative '../../errores/turno/turno_estado_invalido_error'

module EstadoTurnoID
  CANCELADO = -2
  AUSENTE = -1
  PENDIENTE = 0
  ASISTIDO = 1
end

class EstadoTurnoFactory
  def self.crear(estado_turno_id)
    case estado_turno_id
    when EstadoTurnoID::PENDIENTE
      EstadoTurno.new(EstadoTurnoID::PENDIENTE, 'Pendiente')
    when EstadoTurnoID::ASISTIDO
      EstadoTurno.new(EstadoTurnoID::ASISTIDO, 'Asistido')
    when EstadoTurnoID::AUSENTE
      EstadoTurno.new(EstadoTurnoID::AUSENTE, 'Ausente')
    when EstadoTurnoID::CANCELADO
      EstadoTurno.new(EstadoTurnoID::CANCELADO, 'Cancelado')
    else
      raise TurnoEstadoInvalidoError, estado_turno_id
    end
  end
end
