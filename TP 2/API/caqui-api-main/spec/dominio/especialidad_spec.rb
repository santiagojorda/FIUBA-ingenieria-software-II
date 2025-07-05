require 'integration_helper'

describe Especialidad do
  it 'deberia poder crear una especialidad' do
    especialidad = described_class.new('Clinico', 15, nil)
    nombre = especialidad.nombre
    duracion = especialidad.tiempo_atencion
    expect(nombre).to eq 'Clinico'
    expect(duracion).to eq 15
  end
end
