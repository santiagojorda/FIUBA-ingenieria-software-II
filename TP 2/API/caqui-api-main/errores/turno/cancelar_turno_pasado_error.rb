class CancelarTurnoPasadoError < StandardError
  def initialize(turno, proveedor_fecha)
    super("El horario del turno #{turno.id} ya ha pasado, no se puede cancelar. (Horario del turno #{turno.fecha} y el horario actual es #{proveedor_fecha.ahora})")
  end
end
