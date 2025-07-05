require 'spec_helper'
require_relative './promocion_nula'

describe Envio do

  it 'costo es la suma de los costos de los paquetes' do
    envio = Envio.new('123')
    envio.agregar(PaqueteCuadrado.new())
    expect(envio.costo_por_paquetes).to eq 2
  end

  it 'se aplica un recargo de 10 % cuando el volumen < 5' do
    envio = Envio.new('123')
    envio.agregar(PaqueteCuadrado.new())
    envio.agregar(PaqueteCuadrado.new())
    expect(envio.costo_base).to eq 4.4
  end

  it 'costo_total aplica promocion' do
    envio = Envio.new('123')
    promocion_nula = PromocionNula.new
    envio.agregar_promocion(promocion_nula)
    envio.agregar(PaqueteCuadrado.new())
    envio.costo_total
    expect(promocion_nula.fue_invocada).to eq true
  end

  it 'el volumen del envio es cero cuando esta vacio' do
    envio = Envio.new('123')
    expect(envio.volumen).to eq 0
  end

  it 'el volumen del envio es igual al volumen del paquete unico' do
    envio = Envio.new('123')
    paquete = PaqueteCuadrado.new()
    envio.agregar(paquete)
    expect(envio.volumen).to eq paquete.volumen
  end

  it 'el volumen del envio es la suma de los paquetes' do
    envio = Envio.new('123')
    envio.agregar(PaqueteCuadrado.new)
    envio.agregar(PaqueteCuadrado.new)
    expect(envio.volumen).to eq 2
  end

  it 'cantidadDePaquetes filtra los paquetes por clase' do
    envio = Envio.new('123')
    envio.agregar(PaqueteCuadrado.new)
    expect(envio.cantidad_de_paquetes(PaqueteCuadrado)).to eq 1
  end

  it 'envio con 2 triangulos no es valido' do
    envio = Envio.new('123')
    envio.agregar(PaqueteTriangular.new)
    envio.agregar(PaqueteTriangular.new)
    expect{envio.costo_total}.to raise_error StandardError
  end
end
