class Envio
  attr_reader :id

  def initialize(id)
    @id = id
    @paquetes = []
    @promociones = []
  end

  def agregar(paquete)
    @paquetes << paquete
  end

  def costo_por_paquetes
    costo = 0
    @paquetes.each do |paquete|
      costo += paquete.class.costo
    end
    costo
  end

  def costo_base
    return costo_por_paquetes * 1.1 if volumen < 5

    costo_por_paquetes
  end

  def volumen
    contador_volumen = 0
    @paquetes.each do |paquete|
      contador_volumen += paquete.volumen
    end
    contador_volumen
  end

  def cantidad_de_paquetes(tipo)
    contador = 0
    @paquetes.each do |paquete|
      contador += 1 if paquete.instance_of?(tipo)
    end
    contador
  end

  def agregar_promocion(promocion_nula)
    @promociones << promocion_nula
  end

  def costo_total
    validar_envio
    costo = costo_base
    @promociones.each do |promocion|
      delta = promocion.aplicar(self)
      costo += delta
    end
    costo
  end

  private

  def validar_envio
    raise StandardError, 'ENVIO_VACIO' if @paquetes.empty?
    raise StandardError, 'ENVIO_NO_VALIDO' if cantidad_de_paquetes(PaqueteTriangular) > 1
    raise StandardError, 'ENVIO_DEMASIADO_GRANDE' if @paquetes.size > 8
  end
end
