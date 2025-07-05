require 'integration_helper'

describe Medico do
  it 'deberia poder crear un medico' do
    especialidad = Especialidad.new('Clinico', 15)
    medico = described_class.new('Santiago', especialidad, '102_924', true)
    expect(medico.nombre).to eq 'Santiago'
    expect(medico.especialidad).to eq especialidad
    expect(medico.matricula).to eq '102_924'
  end

  it 'deberia poder obtener la duracion de la atencion del medico' do
    especialidad = Especialidad.new('Clinico', 15)
    medico = described_class.new('Santiago', especialidad, '102_924', true)
    expect(medico.tiempo_atencion).to eq 15
  end
end
