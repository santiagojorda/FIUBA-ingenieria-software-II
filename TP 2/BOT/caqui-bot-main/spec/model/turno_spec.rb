require 'spec_helper'
require_relative '../../model/turno'

describe 'Turno' do
  let(:medico) do
    instance_double('Medico', nombre: 'pedro', especialidad: 'ginecologo', id: 2)
  end
  let(:paciente) do
    instance_double('Paciente', nombre: 'fran', dni: 41_231, mail: 'fran@test.com', usuario: 'francabj23')
  end

  it 'debe poder crearse un turno con un medico y un horario' do
    horario = '10/12 08:00'
    turno = Turno.new(medico, horario, paciente)
    expect(turno.horario).to eq(horario)
    expect(turno.paciente).to eq(paciente)
    expect(turno.medico).to eq(medico)
  end
end
