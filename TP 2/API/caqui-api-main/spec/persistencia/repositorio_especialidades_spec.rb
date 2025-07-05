require 'integration_helper'

describe RepositorioEspecialidades do
  it 'deberia guardar y asignar id si la especialidad es nueva' do
    especialidad = Especialidad.new('Clinico', 15, nil)
    described_class.new.save(especialidad)
    expect(especialidad.id).not_to be_nil
  end

  it 'deberia recuperar todas las especialidades' do
    repositorio = described_class.new
    cantidad_inicial = repositorio.all.size
    especialidad = Especialidad.new('Pediatria', 60, nil)
    repositorio.save(especialidad)
    expect(repositorio.all.size).to eq(cantidad_inicial + 1)
  end

  it 'buscando especialidad existente por nombre' do
    repositorio = described_class.new
    especialidad = Especialidad.new('Cardiologia', 30, nil)
    repositorio.save(especialidad)

    especialidad_encontrada = repositorio.buscar_por_nombre(especialidad.nombre)
    expect(especialidad_encontrada.nombre).to eq(especialidad.nombre)
  end

  it 'buscando especialidad que no existe por nombre' do
    repositorio = described_class.new
    especialidad_encontrada = repositorio.buscar_por_nombre('Neurologia')
    expect(especialidad_encontrada).to be_nil
  end
end
