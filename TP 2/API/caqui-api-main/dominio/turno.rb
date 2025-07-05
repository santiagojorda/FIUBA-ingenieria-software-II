require_relative '../errores/turno/estado_inmutable_error'
require_relative '../errores/turno/inasistencia_anticipada_error'
require_relative '../errores/turno/cancelar_turno_pasado_error'

class Turno
  attr_reader :paciente, :medico, :fecha, :estado, :created_on, :updated_on
  attr_accessor :id

  def initialize(medico, paciente, fecha, estado: nil, id: nil)
    @id = id
    @medico = medico
    @paciente = paciente
    @fecha = fecha
    @estado = estado || EstadoTurnoFactory.crear(EstadoTurnoID::PENDIENTE)
  end

  def duracion
    medico.especialidad.tiempo_atencion
  end

  def confirmar_asistencia(_proveedor_fecha)
    validar_mutabilidad_estado
    @estado = EstadoTurnoFactory.crear(EstadoTurnoID::ASISTIDO)
  end

  def confirmar_ausencia(proveedor_fecha)
    validar_mutabilidad_estado
    validar_inasistencia_no_anticipada(proveedor_fecha)
    @estado = EstadoTurnoFactory.crear(EstadoTurnoID::AUSENTE)
  end

  def cancelar(proveedor_fecha)
    validar_mutabilidad_estado
    raise CancelarTurnoPasadoError.new(self, proveedor_fecha) if @fecha <= proveedor_fecha.ahora

    @estado = EstadoTurnoFactory.crear(EstadoTurnoID::CANCELADO)
  end

  private

  def validar_inasistencia_no_anticipada(proveedor_fecha)
    raise InasistenciaAnticipadaError if @fecha > proveedor_fecha.ahora
  end

  def validar_mutabilidad_estado
    raise EstadoInmutableError, self unless estado.id == EstadoTurnoID::PENDIENTE
  end
end
