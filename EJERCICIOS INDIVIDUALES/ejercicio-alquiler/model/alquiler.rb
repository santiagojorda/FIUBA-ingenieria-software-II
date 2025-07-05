class Alquiler
  COSTO_AUTO_HORA = 99
  COSTO_RENTA_DIA = 2001
  COSTO_AUTO_BASE = 100
  COSTO_AUTO_KILOMETRO = 10
  DESCUENTO_CUIT = 0.05
  GANANCIA_PORCENTAJE = 0.45
  CUIT_TIPO_CON_DESCUENTO = 26

  def truncar_a_un_decimal(numero)
    (numero * 10).truncate / 10.0
  end

  def formatear_resultado(importe, ganancia)
    importe = truncar_a_un_decimal(importe)
    ganancia = truncar_a_un_decimal(ganancia)
    { importe: importe, ganancia: ganancia }
  end

  def calcular_alquiler(tipo, datos, cuit)
    importe = 0
    ganancia = 0
    return formatear_resultado(importe, ganancia) if datos.zero?

    importe = case tipo
              when 'd'
                COSTO_RENTA_DIA * datos
              when 'h'
                COSTO_AUTO_HORA * datos
              when 'k'
                COSTO_AUTO_KILOMETRO * datos + COSTO_AUTO_BASE
              else
                0
              end

    cuit_tipo_persona = cuit[0..1].to_i

    importe *= (1 - DESCUENTO_CUIT) if cuit_tipo_persona == CUIT_TIPO_CON_DESCUENTO

    ganancia = importe * GANANCIA_PORCENTAJE
    importe = truncar_a_un_decimal(importe)
    formatear_resultado(importe, ganancia)
  end
end
