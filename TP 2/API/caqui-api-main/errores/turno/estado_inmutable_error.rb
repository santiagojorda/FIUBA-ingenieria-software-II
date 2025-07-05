class EstadoInmutableError < StandardError
  def initialize(turno)
    super("No es posible modificar el estado del turno ##{turno.id} en fecha #{turno.fecha} ya fue modificada.")
  end
end
