require 'spec_helper'
require_relative '../../model/medico'

describe 'Medico' do
  it 'debe poder crearse un medico con nombre, especialidad y id' do
    medico = Medico.new('pedro', 'ginecologo', 2)
    expect(medico.nombre).to eq('pedro')
    expect(medico.especialidad).to eq('ginecologo')
    expect(medico.id).to eq(2)
  end
end
