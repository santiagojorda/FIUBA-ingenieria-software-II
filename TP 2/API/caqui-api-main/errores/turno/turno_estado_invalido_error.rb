class TurnoEstadoInvalidoError < StandardError
  def initialize(estado_turno_id)
    super("No existe un estado de turno con de id #{estado_turno_id} para ser creado.")
  end
end
