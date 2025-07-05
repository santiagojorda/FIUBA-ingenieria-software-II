class Almacen
  def initialize
    @envios = []
  end

  def agregar(envio)
    @envios << envio
  end

  def cantidad_de_envios
    @envios.size
  end

  def obtener_envio(id)
    @envios.find { |envio| envio.id == id }
  end
end
