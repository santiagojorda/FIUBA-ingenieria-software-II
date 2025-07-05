require 'integration_helper'
require_relative '../../persistencia/repositorio_reputaciones'

describe RepositorioReputaciones do
  it 'deberia guardar y asignar id de reputacion' do
    juan = Paciente.new('juan', 40_867_055, 'juan@test.com', nil, 'juan_telegram')
    RepositorioPacientes.new.save(juan)

    id_paciente = juan.id
    asistencias = 0
    inasistencias = 0
    cancelaciones = 0
    reputacion = Reputacion.new(id_paciente, inasistencias, asistencias, cancelaciones)
    described_class.new.save(reputacion)
    expect(reputacion.id).not_to be_nil
  end

  it 'deberia recuperar todos' do
    repositorio = described_class.new
    juan = Paciente.new('juan', 40_867_055, 'juan@test.com', nil, 'juan_telegram')
    RepositorioPacientes.new.save(juan)

    id_paciente = juan.id
    asistencias = 0
    inasistencias = 0
    cancelaciones = 0
    reputacion = Reputacion.new(id_paciente, inasistencias, asistencias, cancelaciones)
    repositorio.save(reputacion)
    cantidad_de_reputaciones_iniciales = repositorio.all.size

    fran = Paciente.new('fran', 40_097_055, 'juan@test.com', nil, 'fran_telegram')
    RepositorioPacientes.new.save(fran)
    id_paciente = fran.id
    reputacion = Reputacion.new(id_paciente, inasistencias, asistencias, cancelaciones)
    repositorio.save(reputacion)

    expect(repositorio.all.size).to be(cantidad_de_reputaciones_iniciales + 1)
  end

  it 'buscando reputacion existente por id_paciente' do
    repositorio = described_class.new

    juan = Paciente.new('juan', 40_867_055, 'juan@test.com', nil, 'juan_telegram')
    RepositorioPacientes.new.save(juan)

    id_paciente = juan.id
    asistencias = 0
    inasistencias = 0
    cancelaciones = 0
    reputacion = Reputacion.new(id_paciente, inasistencias, asistencias, cancelaciones)
    repositorio.save(reputacion)

    reputacion_encontrada = repositorio.buscar_por_paciente_id(juan.id)
    expect(reputacion_encontrada.id_paciente).to eq(juan.id)
  end

  it 'inasistencias, asistencias y cancelaciones aumentan correctamente' do
    repositorio = described_class.new

    juan = Paciente.new('juan', 40_867_055, 'juan@test.com', nil, 'juan_telegram')
    RepositorioPacientes.new.save(juan)

    id_paciente = juan.id
    asistencias = 0
    inasistencias = 0
    cancelaciones = 0
    reputacion = Reputacion.new(id_paciente, inasistencias, asistencias, cancelaciones)
    repositorio.save(reputacion)

    inasistencias = reputacion.inasistencias
    asistencias = reputacion.asistencias
    cancelaciones = reputacion.cancelaciones

    repositorio.aumentar_inasistencias(juan.id)
    repositorio.aumentar_asistencias(juan.id)
    repositorio.aumentar_cancelaciones(juan.id)
    reputacion_actualizada = repositorio.buscar_por_paciente_id(juan.id)

    expect(reputacion_actualizada.inasistencias).to eq(inasistencias + 1)
    expect(reputacion_actualizada.asistencias).to eq(asistencias + 1)
    expect(reputacion_actualizada.cancelaciones).to eq(cancelaciones + 1)
  end
end
