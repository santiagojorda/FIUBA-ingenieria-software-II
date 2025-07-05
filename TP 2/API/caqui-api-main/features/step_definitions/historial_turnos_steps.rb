Dado('que soy paciente') do
  @fecha_sistema = FechaHorario.new('06/06/2025 20:00')
  crear_sistema_con_fecha_fija(@fecha_sistema)
  @sistema = app.settings.sistema

  @sistema.crear_especialidad('otorrino', 30)
  @sistema.crear_medico('Medico Test', 'otorrino', '1234', true)
  @paciente = @sistema.crear_paciente('paciente_test', '12345678', 'mail@mail.com', 'usuario_test')
end

Y('dado que tengo {string} turnos que reservo y que ya han pasado') do |cantidad_turnos|
  @turnos = []
  cantidad_turnos = cantidad_turnos.to_i
  repo = RepositorioMedicos.new
  repo_turnos = RepositorioTurnos.new
  medico = repo.buscar_por_matricula('1234')
  cantidad_turnos.times do |i|
    fecha_pasada = @fecha_sistema - (1 + i.to_i)
    estado_turno = EstadoTurnoFactory.crear(EstadoTurnoID::ASISTIDO)
    turno = Turno.new(medico, @paciente, fecha_pasada, estado: estado_turno)
    repo_turnos.save(turno)
    @turnos << turno
  end
end

Cuando('solicito ver mi historial de turnos anteriores') do
  get '/historial_turnos/usuario_test', {}, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 200
  @historial_turnos = JSON.parse(last_response.body, symbolize_names: true)
end

Entonces('se muestra una lista con mis {string} últimos turnos, ordenados del más reciente al más antiguo') do |cantidad_turnos|
  cantidad_turnos = cantidad_turnos.to_i
  expect(@historial_turnos.size).to eq cantidad_turnos
  @turnos = @turnos.sort_by(&:fecha).reverse
  (0...cantidad_turnos).each do |i|
    expect(@historial_turnos[i][:id]).to eq @turnos[i].id
  end
end

Y('no tengo turnos anteriores en mi historial') do
  @historial_turnos = []
  expect(@historial_turnos).to be_empty
end

Entonces('el historial de turnos esta vacio') do
  expect(@historial_turnos).to be_empty
end
