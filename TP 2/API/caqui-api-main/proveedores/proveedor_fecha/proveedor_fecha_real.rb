require_relative 'proveedor_fecha'

class ProveedorFechaReal
  include ProveedorFecha

  def ahora
    FechaHorario.new(DateTime.now.new_offset('-03:00'))
  end
end
