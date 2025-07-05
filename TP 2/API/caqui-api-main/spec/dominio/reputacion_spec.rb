require 'integration_helper'
require_relative '../../dominio/reputacion'

describe Reputacion do
  it 'deberia poder crear una Reputacion' do
    id_paciente = 1
    asistencias = 0
    inasistencias = 0
    cancelaciones = 0
    reputacion = described_class.new(id_paciente, inasistencias, asistencias, cancelaciones)
    expect(reputacion.id_paciente).to eq id_paciente
    penalizacion = reputacion.calcular_penalizacion
    expect(penalizacion).to eq 0
  end

  it 'paciente con 9 asistencias y uuna inasistencia deberia tener penalizacion -1' do
    id_paciente = 1
    asistencias = 9
    inasistencias = 1
    cancelaciones = 0
    reputacion = described_class.new(id_paciente, inasistencias, asistencias, cancelaciones)
    penalizacion = reputacion.calcular_penalizacion
    expect(penalizacion).to eq(-1)
  end
end
