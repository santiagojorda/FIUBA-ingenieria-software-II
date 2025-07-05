require 'spec_helper'

describe PaqueteCuadrado do

  it 'costo de paquete cuadrado' do
    envio = Envio.new(1)
    envio.agregar(PaqueteCuadrado.new)
    expect(PaqueteCuadrado.costo).to eq 2
  end

  it 'volumen de paquete cuadrado' do
    paquete = PaqueteCuadrado.new
    expect(paquete.volumen).to eq 1
  end

  it 'costo de paquete redondo' do
    expect(PaqueteRedondo.costo).to eq 4
  end

  it 'volumen de paquete cuadrado' do
    paquete = PaqueteRedondo.new
    expect(paquete.volumen).to eq 2
  end

  it 'costo de paquete triangular' do
    expect(PaqueteTriangular.costo).to eq 3
  end

  it 'volumen de paquete triangular' do
    paquete = PaqueteTriangular.new
    expect(paquete.volumen).to eq 3
  end
end
