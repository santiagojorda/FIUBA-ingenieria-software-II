require 'integration_helper'

describe Paciente do
  it 'deberia poder crear un paciente' do
    paciente = described_class.new('Santiago', 40_867_026, 'santiago@mail.com', nil, 'santi_telegram')
    expect(paciente.nombre).to eq 'Santiago'
    expect(paciente.dni).to eq 40_867_026
    expect(paciente.email).to eq 'santiago@mail.com'
  end
end
