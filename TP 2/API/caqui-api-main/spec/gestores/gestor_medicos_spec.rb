require 'integration_helper'
require_relative '../../gestores/gestor_medicos'

describe GestorMedicos do
  let(:repositorio_medicos) { RepositorioMedicos.new }
  let(:repositorio_especialidades) { RepositorioEspecialidades.new }
  let(:gestor_especialidades) { GestorEspecialidades.new(repositorio_especialidades) }
  let(:gestor_medicos) { described_class.new(repositorio_medicos, repositorio_especialidades) }

  it 'deberia crear un medico con los datos correctos' do
    gestor_especialidades.crear_especialidad('neurologia', 30)
    medico = gestor_medicos.crear_medico('Jose Rodriguez', 'neurologia', 867_026, false)
    expect(medico.nombre).to eq 'Jose Rodriguez'
    expect(medico.especialidad.nombre).to eq 'neurologia'
    expect(medico.matricula).to eq 867_026
  end

  it 'deberia poder buscar un medico por id' do
    gestor_especialidades.crear_especialidad('cardiologia', 45)
    medico = gestor_medicos.crear_medico('Ana Gomez', 'cardiologia', 123_456, true)
    encontrado = gestor_medicos.buscar_por_id(medico.id)
    expect(encontrado.nombre).to eq 'Ana Gomez'
    expect(encontrado.especialidad.nombre).to eq 'cardiologia'
  end
end
