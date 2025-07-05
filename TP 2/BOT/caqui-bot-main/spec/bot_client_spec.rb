require 'spec_helper'
require 'web_mock'
# Uncomment to use VCR
# require 'vcr_helper'

require "#{File.dirname(__FILE__)}/../app/bot_client"

def when_i_send_text(token, message_text)
  body = { "ok": true, "result": [{ "update_id": 693_981_718,
                                    "message": { "message_id": 11,
                                                 "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                                                 "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                                                 "date": 1_557_782_998, "text": message_text,
                                                 "entities": [{ "offset": 0, "length": 6, "type": 'bot_command' }] } }] }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def when_i_send_keyboard_updates(token, message_text, inline_selection)
  body = {
    "ok": true, "result": [{
      "update_id": 866_033_907,
      "callback_query": { "id": '608740940475689651', "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                          "message": {
                            "message_id": 626,
                            "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                            "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                            "date": 1_595_282_006,
                            "text": message_text,
                            "reply_markup": {
                              "inline_keyboard": [
                                [{ "text": 'Jon Snow', "callback_data": '1' }],
                                [{ "text": 'Daenerys Targaryen', "callback_data": '2' }],
                                [{ "text": 'Ned Stark', "callback_data": '3' }]
                              ]
                            }
                          },
                          "chat_instance": '2671782303129352872',
                          "data": inline_selection }
    }]
  }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def then_i_get_text(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544', 'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

def then_i_get_keyboard_message(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544',
              'reply_markup' => '{"inline_keyboard":[[{"text":"Jon Snow","callback_data":"1"},{"text":"Daenerys Targaryen","callback_data":"2"},{"text":"Ned Stark","callback_data":"3"}]]}',
              'text' => 'Quien se queda con el trono?' }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

describe 'BotClient' do
  it 'should get a /version message and respond with current version' do
    token = 'fake_token'

    when_i_send_text(token, '/version')
    then_i_get_text(token, Version.current)

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /say_hi message and respond with Hola Emilio' do
    token = 'fake_token'

    when_i_send_text(token, '/say_hi Emilio')
    then_i_get_text(token, 'Hola, Emilio')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /start message and respond with Hola' do
    token = 'fake_token'

    when_i_send_text(token, '/start')
    then_i_get_text(token, 'Hola, Emilio')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /stop message and respond with Chau' do
    token = 'fake_token'

    when_i_send_text(token, '/stop')
    then_i_get_text(token, 'Chau, egutter')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /api_version message and respond with the actual api version' do
    token = 'fake_token'

    stub_request(:get, "#{ENV['URL_API']}/version")
      .to_return(
        status: 200,
        body: {
          version: '0.1.1'
        }.to_json,
        headers: {}
      )

    when_i_send_text(token, '/api_version')
    then_i_get_text(token, 'versión actual de la API: 0.1.1')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should handle an error in /api_version' do
    token = 'fake_token'

    stub_request(:get, "#{ENV['URL_API']}/version")
      .to_return(
        status: 500,
        body: 'Internal Server Error'
      )

    when_i_send_text(token, '/api_version')
    then_i_get_text(token, 'no se pudo conectar con la API: HTTP 500')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get an unknown message message and respond with Do not understand' do
    token = 'fake_token'

    when_i_send_text(token, '/unknown')
    then_i_get_text(token, 'Uh? No te entiendo! Me repetis la pregunta?')

    app = BotClient.new(token)

    app.run_once
  end

  it 'al registrarme sale registracion exitosa' do
    token = 'fake_token'
    when_i_send_text(token, '/registrar francisco 121 fran@test.com')
    then_i_get_text(token, 'Registracion exitosa')

    url_api = "#{ENV['URL_API']}/paciente"
    stub_request(:post, url_api)
      .with(
        body: '{"nombre":"francisco","dni":121,"email":"fran@test.com","username":"egutter"}'
      )
      .to_return(status: 201, body: '{}', headers: {})

    app = BotClient.new(token)
    app.run_once
  end

  it 'al pedir un turno me devuelve los turnos' do
    token = 'fake_token'
    when_i_send_text(token, '/buscar_turnos 22')
    url_api = "#{ENV['URL_API']}/turnos/22/0/2"
    stub_request(:get, url_api)
      .to_return(status: 200, body: [
        { "fecha": '08/12/2025 10:00' },
        { "fecha": '08/12/2025 10:30' },
        { "fecha": '08/12/2025 11:00' }
      ].to_json, headers: {})

    stub_request(:get, "#{ENV['URL_API']}/medicos/22")
      .to_return(
        status: 200,
        body: {
          id: 22,
          nombre: 'Jose Orejas',
          especialidad: 'Otorrinolaringologo',
          matricula: 12,
          trabaja_feriados: true
        }.to_json,
        headers: {}
      )

    stub_request(:post, 'https://api.telegram.org/botfake_token/sendMessage')
      .to_return(
        status: 200,
        body: { ok: true, result: {} }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    then_i_get_text(token, 'Doctor: Jose Orejas - Otorrinolaringologo')
    app = BotClient.new(token)
    app.run_once
  end

  it 'se puede reservar un turno' do
    token = 'fake_token'
    when_i_send_keyboard_updates(token, 'Turnos disponibles:', 'turno_05/06/2025 08:00_medico_22_nombre_Jose Orejas')
    then_i_get_text(token, 'Elegiste el turno para la 05/06/2025 08:00')

    stub_request(:get, "#{ENV['URL_API']}/medicos/22")
      .to_return(
        status: 200,
        body: {
          id: 22,
          nombre: 'Jose Orejas',
          especialidad: 'Otorrinolaringologo',
          matricula: 12,
          trabaja_feriados: true
        }.to_json,
        headers: {}
      )

    stub_request(:post, "#{ENV['URL_API']}/reservar").to_return(status: 201, body: '{}', headers: {})

    app = BotClient.new(token)
    app.run_once
  end

  it 'paciente puede consultar sus turnos pendientes' do
    token = 'fake_token'

    stub_request(:get, "#{ENV['URL_API']}/turnos_pendientes/egutter/0/10").to_return(
      status: 200,
      body: [
        {
          id_turno: 10,
          fecha: '09/06/2025 08:00',
          nombre_medico: 'Jose Orejas',
          especialidad: 'Otorrinolaringologo'
        }
      ].to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
    when_i_send_text(token, '/turnos_pendientes')

    then_i_get_text(token, "Tus turnos pendientes son:\n\n- ID: 10\n- Fecha: 09/06/2025 08:00 \n- Médico: Jose Orejas \n- Especialidad: Otorrinolaringologo")

    app = BotClient.new(token)
    app.run_once
  end

  it 'paciente puede pedir el historial de sus turnos reservados' do
    token = 'fake_token'

    historial_turnos = [
      {
        id: 1,
        fecha: '08/06/2025 10:00',
        especialidad: 'otorrino',
        nombre_medico: 'Dr. Otorrino',
        estado: 'Asistido'
      },
      {
        id: 2,
        fecha: '07/06/2025 09:00',
        especialidad: 'cardiologia',
        nombre_medico: 'Dra. Cardiologa',
        estado: 'Ausente'
      }
    ]

    stub_request(:get, "#{ENV['URL_API']}/historial_turnos/egutter").to_return(
      status: 200,
      body: historial_turnos.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    when_i_send_text(token, '/historial_turnos')
    then_i_get_text(token,
                    "Tu historial de turnos es:\n\n" \
                      "- ID: 1\n" \
                      "- Fecha: 08/06/2025 10:00\n" \
                      "- Especialidad: otorrino\n" \
                      "- Médico: Dr. Otorrino\n" \
                      "- Estado: Asistido\n\n" \
                      "- ID: 2\n" \
                      "- Fecha: 07/06/2025 09:00\n" \
                      "- Especialidad: cardiologia\n" \
                      "- Médico: Dra. Cardiologa\n" \
                      '- Estado: Ausente')
    app = BotClient.new(token)
    app.run_once
  end

  it 'paciente puede cancelar un turno' do
    token = 'fake_token'
    when_i_send_text(token, '/cancelar_turno 1')
    stub_request(:post, "#{ENV['URL_API']}/turnos/1/cancelar")
      .with(body: '{"usuario":"egutter"}').to_return(status: 200, body: '', headers: {})

    then_i_get_text(token, 'Turno cancelado con exito')
    app = BotClient.new(token)
    app.run_once
  end
end
