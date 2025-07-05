def completar_turnos_de_medico_hasta_proximo_lunes
  repositorio_turnos = RepositorioTurnos.new
  fecha_actual = @fecha_sistema
  fecha_fin = FechaHorario.new('06/06/2025 16:00')
  paciente_falso = crear_paciente

  while fecha_actual < fecha_fin
    repositorio_turnos.save(Turno.new(@medico, paciente_falso, fecha_actual)) if (8..16).include?(fecha_actual.to_datetime.hour)
    fecha_actual += 0.5
  end
end

Dado('existe un medico con turnos disponibles el día lunes') do
  @medico = crear_medico
  completar_turnos_de_medico_hasta_proximo_lunes
end

Dado('hoy es viernes') do
  @fecha_sistema = FechaHorario.new('06/06/2025 20:00')
  crear_sistema_con_fecha_fija(@fecha_sistema)
end

Cuando('paciente busca turnos para el medico') do
  get "/turnos/#{@medico.id}/0/100", {}, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => ENV['AUTH_TOKEN'] }
  expect(last_response.status).to eq 200
end

Entonces('se me ofrecerá turnos a partir del lunes.') do
  response = JSON.parse(last_response.body)
  @fecha_turnos = response.map do |turno|
    FechaHorario.new(turno['fecha'])
  end
  expect(@fecha_turnos).to all(satisfy { |fecha| fecha.to_datetime.wday >= 1 && fecha.to_datetime.wday <= 5 })
  fecha_lunes_proximo = FechaHorario.new('09/06/2025 08:00')
  expect(@fecha_turnos).to all(be >= fecha_lunes_proximo)
end

Dado('hoy es miercoles') do
  @fecha_sistema = FechaHorario.new('04/06/2025 20:00')
  crear_sistema_con_fecha_fija(@fecha_sistema)
end

Dado('existe un médico que NO trabaja los feriados') do
  @medico = crear_medico(trabaja_feriados: false)
end

def consultar_feriados
  get '/proveedor/feriados', {}.to_json, headers_autorizacion
  expect(last_response.status).to eq 200
end

def setear_feriados(feriados = [])
  post '/proveedor/feriados', { fecha_feriados: feriados }.to_json, headers_autorizacion
  expect(last_response.status).to eq 200
end

Cuando('consulto la disponibilidad de ese médico para un día que es feriado y hábil') do
  @fecha_sistema = FechaHorario.new('08/07/2025 20:00')

  setear_feriados([
                    (@fecha_sistema.to_fecha + 1),
                    (@fecha_sistema.to_fecha + 2)
                  ])
  crear_sistema_con_fecha_fija(@fecha_sistema)

  get "/turnos/#{@medico.id}/0/3", {}, headers_autorizacion
  expect(last_response.status).to eq 200
  response = JSON.parse(last_response.body)
  @fecha_turnos = response.map do |turno|
    FechaHorario.new(turno['fecha'])
  end
end

Entonces('NO se ofrecerá turnos para ese día feriado con ese médico.') do
  fecha_dia_habil_proximo = FechaHorario.new('11/07/2025 08:00')
  expect(@fecha_turnos).to all(be >= fecha_dia_habil_proximo)
end

Dado('existe un médico que SI trabaja los feriados') do
  @medico = crear_medico(trabaja_feriados: true)
end

Entonces('SI se ofrecerá turnos para ese día feriado con ese médico.') do
  fecha_feriado = FechaHorario.new('09/07/2025 08:00')
  expect(@fecha_turnos).to all(be >= fecha_feriado)
end
