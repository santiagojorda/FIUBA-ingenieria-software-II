require 'spec_helper'
require_relative '../../model/paciente'

describe 'Paciente' do
  it 'debe poder crearse un paciente con nombre y dni' do
    paciente = Paciente.new('Emilio', 12_345_678, '', '')
    expect(paciente.nombre).to eq('Emilio')
    expect(paciente.dni).to eq(12_345_678)
  end

  it 'debe poder crearse un paciente con mail y usuario' do
    paciente = Paciente.new('', 0, 'frna@test.com', 'franz')
    expect(paciente.mail).to eq('frna@test.com')
    expect(paciente.usuario).to eq('franz')
  end
end
