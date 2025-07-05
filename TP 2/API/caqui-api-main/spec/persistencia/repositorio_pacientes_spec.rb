require 'integration_helper'

describe RepositorioPacientes do
  it 'deberia guardar y asignar id si el paciente es nuevo' do
    juan = Paciente.new('juan', 40_867_055, 'juan@test.com', nil, 'juan_telegram')
    described_class.new.save(juan)
    expect(juan.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    repositorio = described_class.new
    cantidad_de_pacientes_iniciales = repositorio.all.size
    pedro = Paciente.new('pedro', 40_494_949, 'pedro@test.com', nil, 'pedro_telegram')
    repositorio.save(pedro)
    expect(repositorio.all.size).to be(cantidad_de_pacientes_iniciales + 1)
  end

  it 'buscando paciente existente por dni' do
    repositorio = described_class.new
    marcos = Paciente.new('marcos', 40_867_055, 'marcos@test.com', nil, 'marcos_telegram')
    repositorio.save(marcos)

    paciente_encontrado = repositorio.buscar_por_dni(marcos.dni)
    expect(paciente_encontrado.dni).to eq(marcos.dni)
  end

  it 'buscando paciente que no existe por dni' do
    repositorio = described_class.new
    expect { repositorio.buscar_por_dni(99_999_999) }.to raise_error(ArgumentError)
  end
end
