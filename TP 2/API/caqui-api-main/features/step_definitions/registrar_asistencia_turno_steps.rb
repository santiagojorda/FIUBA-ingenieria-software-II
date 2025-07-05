Entonces('el sistema marca el turno como asistido') do
  @turnos = @repo_turnos.buscar_superposiciones(@turno)
end

Entonces('se guarda el registro de la asistencia correctamente') do
  expect(@turnos[0].estado.id).to eq EstadoTurnoID::ASISTIDO
end

Cuando(/^exite un medico con una especialidad registrada$/) do
  @medico = crear_medico
end

Cuando(/^existe un turno para el paciente con el medico$/) do
  @paciente = crear_paciente

  @repo_turnos = RepositorioTurnos.new
  @turno = Turno.new(@medico, @paciente, FechaHorario.new('10/06/2025 08:00'))
  @repo_turnos.save(@turno)
end

Y(/^el personal envía la solicitud con el id_turno de ese turno para registrar su asistencia$/) do
  @fecha_hoy = FechaHorario.new('10/06/2025 10:00')
  crear_sistema_con_fecha_fija(@fecha_hoy)

  @turnos = @repo_turnos.buscar_superposiciones(@turno)
  post "/turnos/#{@turnos[0].id}/asistencia", {}, headers_autorizacion
  expect(last_response.status).to eq 200
end
