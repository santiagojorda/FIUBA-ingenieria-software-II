require 'integration_helper'

describe RepositorioMedicos do
  let(:especialidad) { Especialidad.new('Clinico', 15) }
  let(:repositorio_especialidades) { RepositorioEspecialidades.new }
  let(:repositorio) { described_class.new }

  before(:each) do
    repositorio_especialidades.save(especialidad)
  end

  it 'deberia guardar y asignar id si el medico es nuevo' do
    juan = Medico.new('Juan', especialidad, '102_923', true)
    repositorio.save(juan)
    expect(juan.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    cantidad_de_medicos_iniciales = repositorio.all.size
    juan = Medico.new('Juan', especialidad, '102_924', true)
    repositorio.save(juan)
    expect(repositorio.all.size).to be(cantidad_de_medicos_iniciales + 1)
  end

  it 'buscando medico existente por dni' do
    matricula = '102_925'
    juan = Medico.new('Juan', especialidad, matricula, true)
    repositorio.save(juan)
    medico_encontrado = repositorio.buscar_por_matricula(matricula)
    expect(medico_encontrado.matricula).to eq(matricula)
  end

  it 'buscando medico que no existe por matricula' do
    expect { repositorio.buscar_por_matricula(99_999_999) }.to raise_error(ArgumentError)
  end

  it 'buscando medico que existe por id' do
    pepe = Medico.new('Pepe', especialidad, '103_923', true)
    repositorio.save(pepe)
    medico_encontrado = repositorio.buscar_por_id(pepe.id)
    expect(medico_encontrado.nombre).to eq('Pepe')
    expect(medico_encontrado.matricula).to eq('103_923')
  end
end
