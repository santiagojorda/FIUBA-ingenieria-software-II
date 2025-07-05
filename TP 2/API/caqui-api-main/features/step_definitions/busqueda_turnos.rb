Dado(/^que el paciente está registrado$/) do
  post '/paciente', { nombre: 'pedro', dni: 232_432, email: 'pedro@bu.com' }.to_json, headers_autorizacion
  expect(last_response.status).to eq 201
  @paciente = JSON.parse(last_response.body)
end

Y(/^existen especilidades medicas registradas$/) do
  post '/especialidades', { nombre: 'traumatologia', duracion: 30 }.to_json, headers_autorizacion
  post '/especialidades', { nombre: 'odontologia', duracion: 40 }.to_json, headers_autorizacion
  post '/especialidades', { nombre: 'neurologia', duracion: 20 }.to_json, headers_autorizacion
end

Cuando(/^el paciente pide un turno con un medico especifico$/) do
  post '/medicos', { nombre: 'pedro', especialidad: 'neurologia', matricula: '2332', trabaja_feriados: true }.to_json,
       headers_autorizacion
  expect(last_response.status).to eq 201
  @medico = JSON.parse(last_response.body)
  get "/turnos/#{@medico['id']}/0/2", {}, headers_autorizacion
  expect(last_response.status).to eq 200
  @turnos = JSON.parse(last_response.body)
end

Entonces(/^el sistema muestra los turnos disponibles$/) do
  expect(@turnos).to be_a(Array)
  expect(@turnos.first).to include('fecha')
end

Y(/^los turnos están ordenados desde el más próximo al más lejano$/) do
  @fechas = @turnos.map { |turno| FechaHorario.new(turno['fecha']).to_s }
  expect(@fechas).to eq(@fechas.sort)
end

Y(/^los turnos no superan los (\d+) días desde la fecha actual$/) do |arg|
  fecha_limite = FechaHorario.new(DateTime.now - arg.to_i)
  @turnos.each do |turno|
    fecha = FechaHorario.new(turno['fecha'])
    expect(fecha).to be >= fecha_limite
  end
end

Y(/^los turnos comienzan a partir del día siguiente a la consulta$/) do
  fecha_sistema = FechaHorario.new('10/06/2025 08:00')
  crear_sistema_con_fecha_fija(fecha_sistema)
  fecha_minima = fecha_sistema
  fechas = @turnos.map do |turnos_raw|
    FechaHorario.new(turnos_raw['fecha'])
  end
  expect(fechas.min.to_s).to be > fecha_minima.to_s
end

Cuando('el paciente pide un turno para {string}') do |string|
  post '/medicos', { nombre: string, especialidad: string, matricula: '1234', trabaja_feriados: false }.to_json,
       headers_autorizacion
  expect(last_response.status).to eq 201
  @medico = JSON.parse(last_response.body)
  get "/turnos/#{@medico['id']}/0/2", {}, headers_autorizacion
  expect(last_response.status).to eq 200
  @turnos = JSON.parse(last_response.body)
end

Y('cada turno tiene una duración de {string} minutos') do |arg|
  arg = arg.to_i
  fechas = @turnos.map { |turno| turno['fecha'] }
  hora, minuto = fechas[0].split(' ')[1].split(':')
  hora = hora.to_i
  minuto = minuto.to_i

  hora2, minuto2 = fechas[1].split(' ')[1].split(':')
  hora2 = hora2.to_i
  minuto2 = minuto2.to_i

  diferencia = (hora2 * 60 + minuto2) - (hora * 60 + minuto)
  expect(diferencia).to eq(arg)
end

Cuando('el paciente reserva el {string} a las {string} con un medico especifico') do |dia, hora|
  post '/especialidades', { nombre: 'neurologia', duracion: 30 }.to_json, headers_autorizacion

  post '/medicos', { nombre: 'pedro', especialidad: 'neurologia', matricula: '2332', trabaja_feriados: true }.to_json,
       headers_autorizacion
  expect(last_response.status).to eq 201
  @medico = JSON.parse(last_response.body)

  fecha_turno = FechaHorario.new("#{dia}/2025 #{hora}")
  post '/reservar', { id_medico: @medico['id'], fecha: fecha_turno, dni_paciente: @paciente['dni'] }.to_json, headers_autorizacion
  @turno_reservado = last_response
end

Entonces(/^muestra una reserva exitosa$/) do
  expect(@turno_reservado.status).to eq 201
end
