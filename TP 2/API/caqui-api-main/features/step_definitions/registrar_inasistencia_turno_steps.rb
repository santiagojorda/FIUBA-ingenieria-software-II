Dado('que existe un turno agendado para un paciente el dia {string}') do |fecha|
  @paciente = crear_paciente
  @medico = crear_medico
  @fecha_turno = FechaHorario.new(fecha)

  @repo_turnos = RepositorioTurnos.new
  @turno = Turno.new(@medico, @paciente, @fecha_turno)
  @repo_turnos.save(@turno)
end

Dado('la fecha y hora de dicho turno ya han transcurrido') do
  fecha_sistema = @fecha_turno + 1
  crear_sistema_con_fecha_fija(fecha_sistema)
  expect(@fecha_turno).to be < fecha_sistema
end

Cuando('intento registrar la inasistencia para ese turno') do
  post "/turnos/#{@turno.id}/inasistencia", {}, headers_autorizacion
  @respuesta = last_response
end

Entonces('el sistema permite registrar la inasistencia') do
  expect(@respuesta.status).to eq 200
end

Entonces('la inasistencia queda registrada para ese turno.') do
  turnos = @repo_turnos.buscar_superposiciones(@turno)
  expect(turnos[0].estado.id).to eq EstadoTurnoID::AUSENTE
end

Entonces('el sistema no me permite registrar la inasistencia') do
  expect(@respuesta.status).to eq 409
end
