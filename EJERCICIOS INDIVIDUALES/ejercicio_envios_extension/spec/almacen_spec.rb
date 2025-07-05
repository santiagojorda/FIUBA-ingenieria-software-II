require 'spec_helper'

describe Almacen do

  it 'obtiene los envios agregados' do
    almacen = Almacen.new()
    almacen.agregar(Envio.new(1))
    expect(almacen.cantidad_de_envios).to eq 1
  end

  it 'obtiene los envios agregados' do
    almacen = Almacen.new()
    envio = Envio.new(1)
    almacen.agregar(envio)
    envio_obtenido = almacen.obtener_envio(envio.id)
    expect(envio_obtenido).to eq envio
  end
end
