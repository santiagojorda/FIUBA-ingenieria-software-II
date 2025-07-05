require 'spec_helper'

describe 'PromocionCuadrados' do

  it 'aplica 0 cuando no hay paquetes cuadrados' do
    envio = Envio.new('123')
    envio.agregar(PaqueteTriangular.new())
    promocion = PromocionCuadrados.new
    expect(promocion.aplicar(envio)).to eq 0
  end

  it 'aplica 0 cuando menos de 2 paquetes cuadrados' do
    envio = Envio.new('123')
    envio.agregar(PaqueteCuadrado.new())
    envio.agregar(PaqueteCuadrado.new())
    promocion = PromocionCuadrados.new
    expect(promocion.aplicar(envio)).to eq 0
  end

  it 'aplica -1 cuando hay 4 paquetes cuadrados' do
    envio = Envio.new('123')
    envio.agregar(PaqueteCuadrado.new())
    envio.agregar(PaqueteCuadrado.new())
    envio.agregar(PaqueteCuadrado.new())
    envio.agregar(PaqueteCuadrado.new())
    promocion = PromocionCuadrados.new
    expect(promocion.aplicar(envio)).to eq -1
  end

  it 'aplica -2 cuando hay 5 paquetes cuadrados' do
    envio = Envio.new('123')
    envio.agregar(PaqueteCuadrado.new())
    envio.agregar(PaqueteCuadrado.new())
    envio.agregar(PaqueteCuadrado.new())
    envio.agregar(PaqueteCuadrado.new())
    envio.agregar(PaqueteCuadrado.new())
    promocion = PromocionCuadrados.new
    expect(promocion.aplicar(envio)).to eq -2
  end
end
