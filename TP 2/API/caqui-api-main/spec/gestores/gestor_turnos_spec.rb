require 'integration_helper'

describe GestorTurnos do
  let(:repositorio_medicos) { RepositorioMedicos.new }
  let(:repositorio_especialidades) { RepositorioEspecialidades.new }
  let(:repositorio_turnos) { RepositorioTurnos.new }
  let(:repositorio_pacientes) { RepositorioPacientes.new }
  let(:proveedor_fecha) { ProveedorFechaReal.new }
  let(:gestor_especialidades) { GestorEspecialidades.new(repositorio_especialidades) }
  let(:gestor_medicos) { GestorMedicos.new(repositorio_medicos, repositorio_especialidades) }
  let(:gestor_pacientes) { GestorPacientes.new(RepositorioPacientes.new) }
  let(:gestor_turnos) { described_class.new(repositorio_turnos, repositorio_medicos, repositorio_pacientes) }

  it 'deberia mostrar un listado con los turnos disponibles de un medico' do
    proveedor_feriados = ProveedorFeriadosMock.new([])
    gestor_especialidades.crear_especialidad('neurologia', 30)
    medico = gestor_medicos.crear_medico('Jose Rodriguez', 'neurologia', 867_026, false)
    turnos = gestor_turnos.turnos_disponibles(medico.id, 0, 2, proveedor_fecha.ahora, proveedor_feriados)
    expect(turnos).to be_an(Array)
    expect(turnos.size).to eq 3
  end

  it 'deberia poder reservar un turno' do
    proveedor_feriados = ProveedorFeriadosMock.new([])
    gestor_especialidades.crear_especialidad('cardiologia', 30)
    medico = gestor_medicos.crear_medico('Ana Gomez', 'cardiologia', 123_456, false)
    paciente = gestor_pacientes.crear_paciente('Luis', 12_345_678, 'luis@mail.com', 'luis123')
    turnos = gestor_turnos.turnos_disponibles(medico.id, 0, 2, proveedor_fecha.ahora, proveedor_feriados)

    turno_a_reservar = turnos.first
    turno = gestor_turnos.reservar_turno(medico.id, 'luis123', turno_a_reservar)

    expect(turno.medico.id).to eq medico.id
    expect(turno.paciente.id).to eq paciente.id
    expect(turno.fecha).to eq turno_a_reservar
  end

  it 'devuelve turnos pasados del paciente' do
    gestor_especialidades.crear_especialidad('traumatologia', 30)
    medico = gestor_medicos.crear_medico('Carlos Perez', 'traumatologia', 654_321, false)
    paciente = gestor_pacientes.crear_paciente('Maria', 98_765_432, 'maria@mail.com', 'maria123')
    fecha_pasada = proveedor_fecha.ahora - 72
    turno_pasado = Turno.new(medico, paciente, fecha_pasada)
    repositorio_turnos.save(turno_pasado)
    historial_turnos = gestor_turnos.consultar_historial_turnos('maria123', proveedor_fecha)
    expect(historial_turnos.size).to eq 1
    expect(historial_turnos.first.paciente.id).to eq paciente.id
  end

  it 'confirma asistencia a un turno' do
    gestor_especialidades.crear_especialidad('oftalmologia', 30)
    medico = gestor_medicos.crear_medico('Laura Torres', 'oftalmologia', 321_654, false)
    paciente = gestor_pacientes.crear_paciente('Pedro', 11_223_344, 'pedro@mail.com', 'pedro123')
    fecha_turno = proveedor_fecha.ahora + 48
    turno = Turno.new(medico, paciente, fecha_turno)
    repositorio_turnos.save(turno)
    gestor_turnos.confirmar_asistencia_turno(turno.id, proveedor_fecha)
    turno_confirmado = repositorio_turnos.find(turno.id)
    expect(turno_confirmado.estado.id).to eq EstadoTurnoID::ASISTIDO
    expect(turno_confirmado.paciente.id).to eq paciente.id
    expect(turno_confirmado.medico.id).to eq medico.id
  end

  it 'confirma inasistencia a un turno' do
    gestor_especialidades.crear_especialidad('oftalmologia', 30)
    medico = gestor_medicos.crear_medico('Sofia Torres', 'oftalmologia', 321_688, false)
    paciente = gestor_pacientes.crear_paciente('Lucas', 11_223_355, 'lucas@mail.com', 'lucas')
    fecha_turno = proveedor_fecha.ahora - 48
    turno = Turno.new(medico, paciente, fecha_turno)
    repositorio_turnos.save(turno)
    gestor_turnos.confirmar_ausencia_turno(turno.id, proveedor_fecha)
    turno_confirmado = repositorio_turnos.find(turno.id)
    expect(turno_confirmado.estado.id).to eq EstadoTurnoID::AUSENTE
    expect(turno_confirmado.paciente.id).to eq paciente.id
    expect(turno_confirmado.medico.id).to eq medico.id
  end

  it 'busca turnos pendientes por paciente' do
    gestor_especialidades.crear_especialidad('ginecologia', 30)
    medico = gestor_medicos.crear_medico('Ana Lopez', 'ginecologia', 987_654, false)
    paciente = gestor_pacientes.crear_paciente('Clara', 22_334_455, 'clara@mail.com', 'clara123')
    fecha_turno1 = proveedor_fecha.ahora + 24
    fecha_turno2 = proveedor_fecha.ahora + 48
    turno1 = Turno.new(medico, paciente, fecha_turno1)
    turno2 = Turno.new(medico, paciente, fecha_turno2)
    repositorio_turnos.save(turno1)
    repositorio_turnos.save(turno2)
    turnos_pendientes = gestor_turnos.buscar_turnos_pendientes_por_paciente('clara123', 0, 1)
    expect(turnos_pendientes.size).to eq 2
    expect(turnos_pendientes.first.paciente.id).to eq paciente.id
    expect(turnos_pendientes.first.medico.id).to eq medico.id
  end

  it 'busca turnos asignados por medico' do
    gestor_especialidades.crear_especialidad('dermatologia', 30)
    medico = gestor_medicos.crear_medico('Javier Gomez', 'dermatologia', 123_789, false)
    paciente = gestor_pacientes.crear_paciente('Lucia', 33_445_566, 'lu@mail.com', 'lucia123')
    fecha_turno1 = proveedor_fecha.ahora + 24
    fecha_turno2 = proveedor_fecha.ahora + 48
    turno1 = Turno.new(medico, paciente, fecha_turno1)
    turno2 = Turno.new(medico, paciente, fecha_turno2)
    repositorio_turnos.save(turno1)
    repositorio_turnos.save(turno2)
    turnos_asignados = gestor_turnos.buscar_turnos_asignados_por_medico(medico.id)
    expect(turnos_asignados.size).to eq 2
    expect(turnos_asignados.first.medico.id).to eq medico.id
    expect(turnos_asignados.first.paciente.id).to eq paciente.id
  end
end
