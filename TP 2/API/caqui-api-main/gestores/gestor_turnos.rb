class GestorTurnos
  FRANJA_HORARIO_INICIO = 8
  FRANJA_HORARIO_FIN = 16
  DIAS_MAX = 60
  CANTIDAD_MAX_HISTORIAL = 4

  def initialize(repositorio_turnos, repositorio_medicos, repositorio_pacientes)
    @repositorio_turnos = repositorio_turnos
    @repositorio_medicos = repositorio_medicos
    @repositorio_pacientes = repositorio_pacientes
  end

  def turnos_disponibles(id_medico, inicio, fin, ahora, proveedor_feriados)
    medico = @repositorio_medicos.buscar_por_id(id_medico)
    generar_turnos(medico, inicio, fin, ahora, proveedor_feriados)
  end

  def reservar_turno(id_medico, username, fecha_hora)
    medico = @repositorio_medicos.buscar_por_id(id_medico)
    paciente = @repositorio_pacientes.buscar_por_usuario_telegram(username)
    turno = Turno.new(medico, paciente, fecha_hora)

    superpuestos = @repositorio_turnos.buscar_superposiciones(turno)
    raise TurnoSuperpuestoError if superpuestos.any? { |t| t.estado.id != EstadoTurnoID::CANCELADO }

    @repositorio_turnos.save(turno)
    turno
  end

  def consultar_historial_turnos(username_paciente, proveedor_fecha)
    paciente = @repositorio_pacientes.buscar_por_usuario_telegram(username_paciente)
    historial_turnos = @repositorio_turnos.buscar_turnos_pasados(paciente, proveedor_fecha).sort_by(&:fecha).reverse
    historial_turnos[0..CANTIDAD_MAX_HISTORIAL]
  end

  def confirmar_asistencia_turno(id_turno, proveedor_fecha)
    turno = @repositorio_turnos.find(id_turno)
    turno.confirmar_asistencia(proveedor_fecha)
    @repositorio_turnos.save(turno)
  end

  def confirmar_ausencia_turno(id_turno, proveedor_fecha)
    turno = @repositorio_turnos.find(id_turno)
    turno.confirmar_ausencia(proveedor_fecha)
    @repositorio_turnos.save(turno)
  end

  def buscar_turnos_pendientes_por_paciente(username_paciente, inicio, fin)
    paciente = @repositorio_pacientes.buscar_por_usuario_telegram(username_paciente)
    turnos_pendientes = @repositorio_turnos.buscar_pendientes_por_paciente(paciente)
    turnos_pendientes[inicio..fin]
  end

  def buscar_turnos_asignados_por_medico(medico_id)
    medico = @repositorio_medicos.buscar_por_id(medico_id)
    @repositorio_turnos.buscar_asignados_por_medico(medico)
  end

  private

  def generar_turnos(medico, inicio, fin, ahora, proveedor_feriados)
    turnos = []

    fecha_base = ahora + 24

    (0...DIAS_MAX).each do |dia_offset|
      fecha_horario = fecha_base + dia_offset
      next if proveedor_feriados.es_feriado?(fecha_horario.to_fecha) && !medico.trabaja_feriados
      next if fecha_horario.es_fin_de_semana?

      turnos_del_dia = generar_turnos_del_dia(fecha_horario, medico)
      turnos.concat(turnos_del_dia)
      break if turnos.size >= fin + 1
    end

    turnos[inicio..fin]
  end

  def generar_turnos_del_dia(fecha, medico)
    turnos = []

    cada_turno_horario(fecha, medico.tiempo_atencion) do |hora|
      turnos << FechaHorario.new(hora.to_datetime) if turno_disponible?(medico, hora)
    end

    turnos
  end

  def cada_turno_horario(fecha, duracion_minutos)
    hora_actual = FechaHorario.new("#{fecha.dia}/#{fecha.mes}/#{fecha.anio} #{FRANJA_HORARIO_INICIO}:00")
    hora_fin = FechaHorario.new("#{fecha.dia}/#{fecha.mes}/#{fecha.anio} #{FRANJA_HORARIO_FIN}:00")
    paso = duracion_minutos.to_f / 60

    while hora_actual + paso <= hora_fin
      yield hora_actual
      hora_actual += paso
    end
  end

  def turno_disponible?(medico, hora)
    turno_ficticio = construir_turno_ficticio(medico, hora)
    turnos_existentes = @repositorio_turnos.buscar_superposiciones(turno_ficticio)
    turnos_existentes.empty? || turnos_existentes.all? { |t| t.estado.id == EstadoTurnoID::CANCELADO }
  end

  def construir_turno_ficticio(medico, hora)
    Turno.new(
      medico,
      Paciente.new('', 0, '', nil, ''),
      FechaHorario.new(hora.to_datetime)
    )
  end
end
