class PromocionCuadrados
  def aplicar(envio)
    cantidad_cuadrados = envio.cantidad_de_paquetes(PaqueteCuadrado)
    if cantidad_cuadrados < 4
      0
    else
      -1 * (cantidad_cuadrados - 3)
    end
  end
end
