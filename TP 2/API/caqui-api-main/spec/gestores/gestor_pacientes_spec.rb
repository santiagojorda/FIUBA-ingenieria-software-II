require 'integration_helper'
require_relative '../../gestores/gestor_pacientes'

describe GestorPacientes do
  let(:repositorio_pacientes) { RepositorioPacientes.new }
  let(:gestor) { described_class.new(repositorio_pacientes) }

  describe 'deberia poder crear un paciente' do
    it 'deberia crear un paciente con los datos correctos' do
      paciente = gestor.crear_paciente('Santiago', 40_867_026, 'santiago@mail.com', 'santi_telegram')
      expect(paciente.nombre).to eq 'Santiago'
    end
  end
end
