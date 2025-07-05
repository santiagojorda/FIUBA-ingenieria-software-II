require 'spec_helper'

describe Correo do

  it 'asigna id a los envios creados' do
    almacen_de_paquetes = Almacen.new
    correo = Correo.new(almacen_de_paquetes)
    id = correo.crear_envio
    expect(id).not_to be_nil
  end

  it 'los ids asignados son unicos' do
    almacen_de_paquetes = Almacen.new
    correo = Correo.new(almacen_de_paquetes)
    un_id = correo.crear_envio
    otro_id = correo.crear_envio
    expect(un_id).not_to eq otro_id
  end

  it 'agregar paquete al envio' do
    almacen_de_paquetes = Almacen.new
    correo = Correo.new(almacen_de_paquetes)
    id = correo.crear_envio
    correo.agregar_paquete(id, 'C')
    expect(almacen_de_paquetes.cantidad_de_envios).to eq 1
  end

  it 'checkout genera una factura' do
    almacen_de_paquetes = Almacen.new
    correo = Correo.new(almacen_de_paquetes)
    id = correo.crear_envio
    correo.agregar_paquete(id, 'C')
    factura = correo.checkout(id)
    expect(factura.volumen_envio).to eq 1
    expect(factura.importe).to eq 2.2
  end
end
