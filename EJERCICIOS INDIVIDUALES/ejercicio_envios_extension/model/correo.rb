require 'securerandom'
require_relative './factura'

class Correo
  def initialize(almacen)
    @almacen = almacen
  end

  def crear_envio
    envio = Envio.new(SecureRandom.uuid)
    envio.agregar_promocion(PromocionCuadrados.new)
    @almacen.agregar(envio)
    envio.id
  end

  def agregar_paquete(id_envio, tipo_paquete)
    envio = @almacen.obtener_envio(id_envio)
    raise StandardError, 'ENVIO_INEXISTENTE' if envio.nil?

    paquete = PaqueteCuadrado.new if tipo_paquete == 'C'
    paquete = PaqueteRedondo.new if tipo_paquete == 'R'
    paquete = PaqueteTriangular.new if tipo_paquete == 'T'
    envio.agregar(paquete)
  end

  def checkout(id)
    envio = @almacen.obtener_envio(id)
    factura = Factura.new
    raise StandardError, 'ENVIO_VACIO' if envio.volumen.zero?

    factura.importe = envio.costo_total.round(1)
    factura.volumen_envio = envio.volumen
    factura
  end
end
