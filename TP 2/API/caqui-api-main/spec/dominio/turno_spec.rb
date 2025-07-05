require 'integration_helper'

describe Turno do
  let(:especialidad) { instance_double('Especialidad', tiempo_atencion: 15) }
  let(:fecha_turno) { FechaHorario.new('10/06/2025 10:00') }
  let(:medico) { instance_double('Medico', nombre: 'Santiago', especialidad:) }
  let(:paciente) { instance_double('Paciente', nombre: 'Marcos') }
  let(:proveedor_fecha_real) { ProveedorFechaReal.new }

  def proveedor_fecha_fija_previo_al_turno
    fecha_sistema = FechaHorario.new('10/06/2025 08:00')
    ProveedorFechaFija.new(fecha_sistema)
  end

  def proveedor_fecha_fija_posterior_al_turno
    fecha_sistema = FechaHorario.new('10/06/2025 12:00')
    ProveedorFechaFija.new(fecha_sistema)
  end

  it 'deberia poder crear un turno' do
    turno = described_class.new(medico, paciente, fecha_turno)

    expect(turno).to have_attributes(
      medico:,
      paciente:,
      fecha: fecha_turno,
      duracion: 15
    )

    expect(turno.estado.id).to eq EstadoTurnoID::PENDIENTE
  end

  describe 'confirmar asistencia' do
    it 'deberia poder marcar como asistido un turno en pendiente' do
      turno = described_class.new(medico, paciente, fecha_turno)
      expect(turno.estado.id).to eq EstadoTurnoID::PENDIENTE
      turno.confirmar_asistencia(proveedor_fecha_fija_posterior_al_turno)
      expect(turno.estado.id).to eq EstadoTurnoID::ASISTIDO
    end

    it 'no deberia poder marcar como asistido un turno marcado si no asistio' do
      turno = described_class.new(medico, paciente, fecha_turno, estado: EstadoTurnoFactory.crear(EstadoTurnoID::AUSENTE))
      expect(turno.estado.id).to eq EstadoTurnoID::AUSENTE
      expect { turno.confirmar_asistencia(proveedor_fecha_fija_posterior_al_turno) }.to raise_error(EstadoInmutableError)
      expect(turno.estado.id).to eq EstadoTurnoID::AUSENTE
    end
  end

  describe 'confirmar ausencia' do
    it 'no deberia poder marcar como no asistido un turno no pendiente' do
      turno = described_class.new(medico, paciente, fecha_turno, estado: EstadoTurnoFactory.crear(EstadoTurnoID::ASISTIDO))
      expect(turno.estado.id).to eq EstadoTurnoID::ASISTIDO
      expect { turno.confirmar_ausencia(proveedor_fecha_fija_posterior_al_turno) }.to raise_error(EstadoInmutableError)
      expect(turno.estado.id).to eq EstadoTurnoID::ASISTIDO
    end

    it 'deberia poder marcar como no asistido un turno en pendiente' do
      turno = described_class.new(medico, paciente, fecha_turno)
      expect(turno.estado.id).to eq EstadoTurnoID::PENDIENTE
      turno.confirmar_ausencia(proveedor_fecha_fija_posterior_al_turno)
      expect(turno.estado.id).to eq EstadoTurnoID::AUSENTE
    end
  end

  describe 'cancelar' do
    it 'no deberia poder cancelar un turno que ya paso' do
      turno = described_class.new(medico, paciente, fecha_turno)
      expect(turno.estado.id).to eq EstadoTurnoID::PENDIENTE
      expect { turno.cancelar(proveedor_fecha_fija_posterior_al_turno) }.to raise_error(CancelarTurnoPasadoError)
    end

    it 'no se puede cancelar un turno que ya fue cancelado' do
      turno = described_class.new(medico, paciente, fecha_turno)
      turno.cancelar(proveedor_fecha_fija_previo_al_turno)
      expect(turno.estado.id).to eq EstadoTurnoID::CANCELADO
      expect { turno.cancelar(proveedor_fecha_fija_posterior_al_turno) }.to raise_error(EstadoInmutableError)
    end
  end
end
