Dado('que un paciente tiene 10 turnos en su historial') do
  fecha = FechaHorario.new('18/05/2025 15:30')
  crear_sistema_con_fecha_fija(fecha)
  post '/medicos', { nombre: 'Dr. Smith', especialidad: 'traumatologia', matricula: '1234', trabaja_feriados: false }.to_json, headers_autorizacion
  @medico = JSON.parse(last_response.body)
  fechas = []
  fechas[0] = '19/05/2025 15:30'
  fechas[1] = '19/05/2025 16:30'
  fechas[2] = '19/05/2025 17:00'
  fechas[3] = '19/05/2025 17:30'
  fechas[4] = '19/05/2025 18:00'
  fechas[5] = '19/05/2025 18:30'
  fechas[6] = '20/05/2025 15:00'
  fechas[7] = '20/05/2025 15:30'
  fechas[8] = '20/05/2025 16:30'
  fechas[9] = '20/05/2025 17:30'
  @turno_id = []
  i = 0
  post '/paciente', { nombre: 'Laura', dni: 456_432, email: 'laura@mail.com', username: 'laura' }.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  @paciente = JSON.parse(last_response.body)
  fechas.each do |_fecha|
    post 'reservar', { id_medico: @medico['id'], fecha: fechas[i], dni_paciente: @paciente['dni'], username: @paciente['username'] }.to_json, headers_autorizacion
    expect(last_response.status).to eq 201
    @turno_id[i] = JSON.parse(last_response.body)['id_turno']
    i += 1
  end
end

Y('tiene 1 inasistencia y 9 asistencias') do
  fecha2 = FechaHorario.new('18/06/2025 15:30')
  crear_sistema_con_fecha_fija(fecha2)
  post "turnos/#{@turno_id[0]}/inasistencia", {}, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  puts "Turno marcado como inasistencia: #{@turno_id[0]}"
  expect(last_response.status).to eq 200

  (1..9).each do |i|
    post "turnos/#{@turno_id[i]}/asistencia", {}, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
    expect(last_response.status).to eq 200
  end
end

Cuando('el paciente intenta sacar mas de un turno') do
  post '/reservar', { id_medico: @medico['id'], fecha: '25/06/2025 17:30', dni_paciente: @paciente['dni'], username: @paciente['username'] }.to_json,
       { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN']  }
  expect(last_response.status).to eq 201
  post '/reservar', { id_medico: @medico['id'], fecha: '26/06/2025 17:30', dni_paciente: @paciente['dni'], username: @paciente['username'] }.to_json,
       { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN']  }
  @respuesta_status = last_response.status
  @respuesta_body = last_response.body
end

Entonces('solo se le permite un turno pendiente') do
  puts "Status de la respuesta: #{@respuesta_status}"
  puts "Cuerpo de la respuesta: #{@respuesta_body}"
  expect(@respuesta_status).to eq 408
end

Y('el paciente reserva un turno nuevo y asiste al mismo') do
  post '/reservar', { id_medico: @medico['id'], fecha: '27/06/2023 17:30', dni_paciente: @paciente['dni'], username: @paciente['username'] }.to_json,
       { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN']  }
  expect(last_response.status).to eq 201
  @turno_reservado = JSON.parse(last_response.body)

  post "turnos/#{@turno_reservado['id_turno']}/asistencia", {}, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 200
end

Entonces('el paciente deja de estar penalizado') do
  post '/reservar', { id_medico: @medico['id'], fecha: '30/06/2023 17:30', dni_paciente: @paciente['dni'], username: @paciente['username'] }.to_json,
       { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN']  }
  expect(last_response.status).to eq 201

  post '/reservar', { id_medico: @medico['id'], fecha: '30/06/2023 18:00', dni_paciente: @paciente['dni'], username: @paciente['username'] }.to_json,
       { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN']  }
  expect(last_response.status).to eq 201
end
