require_relative 'proveedor_fecha'

class ProveedorFechaFija
  include ProveedorFecha

  def initialize(fecha_fija)
    raise ArgumentError, 'La fecha fija debe ser un objeto FechaHorario.' unless fecha_fija.is_a?(FechaHorario)

    @fecha_fija = fecha_fija
  end

  def ahora
    @fecha_fija
  end
end
