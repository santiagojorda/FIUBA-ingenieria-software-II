require 'integration_helper'

describe RepositorioTurnos do
  let(:especialidad) { Especialidad.new('Clinico', 15) }
  let(:medico) { Medico.new('Santiago', especialidad, '102_924', true) }
  let(:paciente) do
    paciente_aux = Paciente.new('Marcos', 40_881_223, 'marcos@mail.com', nil, 'juan-telegram')
    RepositorioPacientes.new.save(paciente_aux)
    paciente_aux
  end
  let(:repositorio_turnos) { described_class.new }
  let(:fecha_sistema) { FechaHorario.new('10/06/2025 12:00') }
  let(:proveedor_fecha_fija) { ProveedorFechaFija.new(fecha_sistema) }

  before(:each) do
    repositorio_especialidades = RepositorioEspecialidades.new
    repositorio_especialidades.save(especialidad)
    repositorio_medicos = RepositorioMedicos.new
    repositorio_medicos.save(medico)
  end

  it 'deberia guardar y asignar id si el turno es nuevo' do
    fecha_turno = FechaHorario.new('10/10/2025 10:00')
    turno = Turno.new(medico, paciente, fecha_turno)
    repositorio_turnos.save(turno)
    expect(turno.id).not_to be_nil
  end

  it 'deberia recuperar todos los turnos' do
    fecha_turno = FechaHorario.new('10/10/2025 10:00')
    cantidad_de_turnos_iniciales = repositorio_turnos.all.size
    turno = Turno.new(medico, paciente, fecha_turno)
    repositorio_turnos.save(turno)
    expect(repositorio_turnos.all.size).to be(cantidad_de_turnos_iniciales + 1)
  end

  it 'buscando turno existente por id' do
    fecha_turno = FechaHorario.new('10/10/2025 10:00')
    turno = Turno.new(medico, paciente, fecha_turno)
    repositorio_turnos.save(turno)
    turno_entontrado = repositorio_turnos.find(turno.id)
    expect(turno_entontrado.id).to eq(turno.id)
  end

  it 'buscando turno que no existe por id' do
    expect { repositorio_turnos.find(9999) }.to raise_error(ObjetoNoEncontrado)
  end

  it 'buscando turno por superposicion' do
    fecha_turno = FechaHorario.new('10/10/2025 10:00')
    turno = Turno.new(medico, paciente, fecha_turno)
    repositorio_turnos.save(turno)
    turnos_entontrados = repositorio_turnos.buscar_superposiciones(turno)
    expect(turnos_entontrados[0].id).to eq(turno.id)
  end

  it 'traer todos los turnos historicos de un paciente' do
    fecha_turno = FechaHorario.new('10/01/2025 10:00')
    turno = Turno.new(medico, paciente, fecha_turno)
    repositorio_turnos.save(turno)
    fecha_turno = FechaHorario.new('11/01/2025 10:00')
    turno2 = Turno.new(medico, paciente, fecha_turno)
    repositorio_turnos.save(turno2)
    turnos_historicos = repositorio_turnos.buscar_turnos_paciente(paciente)
    expect(turnos_historicos.size).to eq(2)
  end

  describe 'busqueda de turnos paciente ya pasados' do
    it 'solo trae turnos pasados' do
      turno_futuro = Turno.new(medico, paciente, fecha_sistema + 26)
      turno_pasado1 = Turno.new(medico, paciente, fecha_sistema - 26)
      turno_pasado1.confirmar_asistencia(proveedor_fecha_fija)
      turno_pasado2 = Turno.new(medico, paciente, fecha_sistema - 2)
      turno_pasado2.confirmar_ausencia(proveedor_fecha_fija)

      repositorio_turnos.save(turno_futuro)
      repositorio_turnos.save(turno_pasado1)
      repositorio_turnos.save(turno_pasado2)

      turnos_filtrados = repositorio_turnos.buscar_turnos_pasados(paciente, proveedor_fecha_fija)

      turnos_filtrados.each do |turno|
        expect(turno.id).not_to be turno_futuro.id
      end
    end
  end

  describe 'buscando superposicion' do
    it 'se cancela un turno y luego obtengo el cancelado' do
      turno_cancelado = Turno.new(medico, paciente, fecha_sistema + 26)
      turno_cancelado.cancelar(proveedor_fecha_fija)
      repositorio_turnos.save(turno_cancelado)
      turnos_filtrados = repositorio_turnos.buscar_superposiciones(turno_cancelado)
      expect(turnos_filtrados.size).to eq(1)
      expect(turnos_filtrados[0].id).to eq(turno_cancelado.id)
    end

    it 'se cancela varios turnos en el mismo horario y luego los obtengo' do
      turno_cancelado1 = Turno.new(medico, paciente, fecha_sistema + 25)
      turno_cancelado2 = Turno.new(medico, paciente, fecha_sistema + 25)

      turno_cancelado1.cancelar(proveedor_fecha_fija)
      repositorio_turnos.save(turno_cancelado1)

      turno_cancelado2.cancelar(proveedor_fecha_fija)
      repositorio_turnos.save(turno_cancelado2)

      turnos_filtrados = repositorio_turnos.buscar_superposiciones(turno_cancelado2)
      expect(turnos_filtrados.size).to eq(2)
      expect(turnos_filtrados[0].fecha).to eq(turno_cancelado1.fecha)
      expect(turnos_filtrados[1].fecha).to eq(turno_cancelado2.fecha)
    end
  end

  describe 'buscando turnos asignados por medico' do
    it 'deberia traer turnos asignados por medico' do
      fecha_turno = FechaHorario.new('10/10/2025 10:00')
      turno = Turno.new(medico, paciente, fecha_turno)
      repositorio_turnos.save(turno)
      turnos_asignados = repositorio_turnos.buscar_asignados_por_medico(medico)
      expect(turnos_asignados.size).to eq(1)
      expect(turnos_asignados[0].id).to eq(turno.id)
      expect(turnos_asignados[0].estado.id).to eq(EstadoTurnoID::PENDIENTE)
    end

    it 'deberia devolver una lista vacia si no hay turnos asignados' do
      medico_sin_turnos = Medico.new('Dr. House', especialidad, 102_925, true)
      repositorio_medicos = RepositorioMedicos.new
      repositorio_medicos.save(medico_sin_turnos)
      turnos_asignados = repositorio_turnos.buscar_asignados_por_medico(medico_sin_turnos)
      expect(turnos_asignados).to be_empty
    end
  end
end
