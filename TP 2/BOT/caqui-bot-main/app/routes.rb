require "#{File.dirname(__FILE__)}/../lib/routing"
require "#{File.dirname(__FILE__)}/../lib/version"
require_relative '../model/sistema'
require_relative '../conectores/conector_api'
require_relative 'generador_botones'
require_relative 'mensajes_const'

MEDICO_ID_POSICION = 2
FECHA_POSICION = 1
class Routes
  include Routing

  @logger = SemanticLogger['Routes']
  @conector = ConectorAPI.new(@logger)
  @sistema = Sistema.new(@conector)

  on_message '/start' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "#{HOLA_MSG}#{message.from.first_name}")
  end

  on_message_pattern %r{/say_hi (?<name>.*)} do |bot, message, args|
    bot.api.send_message(chat_id: message.chat.id, text: "#{HOLA_MSG}#{args['name']}")
  end

  on_message '/stop' do |bot, message|
    @logger.info 'llamado a stop'
    bot.api.send_message(chat_id: message.chat.id, text: "#{CHAU_MSG}#{message.from.username}")
  end

  on_message '/version' do |bot, message|
    @logger.info "Version: #{Version.current}"
    bot.api.send_message(chat_id: message.chat.id, text: Version.current)
  end

  on_message '/api_version' do |bot, message|
    version = @conector.obtener_version_api
    bot.api.send_message(
      chat_id: message.chat.id,
      text: "#{VERSION_MSG}#{version}"
    )
  rescue StandardError => e
    bot.api.send_message(
      chat_id: message.chat.id,
      text: "#{ERROR_API_MSG}#{e.message}"
    )
  end

  on_message_pattern %r{/registrar (?<nombre>\S+) (?<dni>\d+) (?<email>\S+)} do |bot, message, args|
    begin
      @sistema.registrar_nuevo_paciente(args['nombre'], args['dni'].to_i, args['email'], message.from.username)
    rescue ErrorDeRegistracion => _e
      bot.api.send_message(chat_id: message.chat.id, text: ERROR_REGISTRAR_MSG.to_s)
      next
    end
    bot.api.send_message(chat_id: message.chat.id, text: OK_REGISTRAR_MSG.to_s)
  end

  on_message_pattern %r{/buscar_turnos (?<medico_id>\d+)} do |bot, message, args|
    begin
      turnos = @sistema.buscar_turnos_por_medico(args['medico_id'].to_i, 0, 2)
    rescue ObjetoNoEncontrado => _e
      bot.api.send_message(chat_id: message.chat.id, text: ERROR_TURNOS_MEDICO_MSG.to_s)
      next
    end
    if turnos.size.positive?
      generador = GeneradorDeBotones.new(turnos.map(&:horario), turnos.map(&:callbacks_pedir_turno))
      bot.api.send_message(chat_id: message.chat.id, text: "#{DOCTOR_MSG}#{turnos[0].medico.info_s}")
      bot.api.send_message(chat_id: message.chat.id, text: TURNOS_DISPONIBLES_MSG.to_s, reply_markup: generador.markup.to_json)
    else
      bot.api.send_message(chat_id: message.chat.id, text: TURNOS_NO_DISPONIBLES_MSG.to_s)
    end
  end

  on_response_to 'Turnos disponibles:' do |bot, message|
    datos = message.data.match(/^turno_(.+)_medico_(\d+)_nombre_(.+)$/)
    id_medico = datos[MEDICO_ID_POSICION]
    fecha = datos[FECHA_POSICION]

    begin
      @sistema.reservar_turnos_por_medico(id_medico, fecha, message.from.username)
    rescue TurnoError => _e
      bot.api.send_message(chat_id: message.message.chat.id, text: TURNO_OCUPADO_MSG.to_s)
      next
    rescue UsuarioPen => _e
      bot.api.send_message(chat_id: message.message.chat.id, text: USUARIO_PENALIZADO_MSG.to_s)
      next
    end
    bot.api.send_message(chat_id: message.message.chat.id, text: "#{ELEGIR_TURNO_MSG} #{fecha}")
  end

  on_message_pattern %r{/turnos_pendientes} do |bot, message|
    username = message.from.username
    turnos = @sistema.obtener_turnos_pendientes(username)
    if turnos.any?
      mensaje = turnos.map(&:resumen_pendiente).join("\n\n")
      bot.api.send_message(chat_id: message.chat.id, text: "#{TURNOS_PENDIENTES_MSG}#{mensaje}")
    else
      bot.api.send_message(chat_id: message.chat.id, text: TURNOS_NO_PENDIENTES_MSG.to_s)
    end
  end

  on_message_pattern %r{/historial_turnos} do |bot, message|
    username = message.from.username
    historial_turnos = @sistema.obtener_historial_turnos(username)
    if historial_turnos.any?
      mensaje = historial_turnos.map(&:resumen_historial).join("\n\n")
      bot.api.send_message(chat_id: message.chat.id, text: "#{HISTORIAL_TURNOS_MSG}#{mensaje}")
    else
      bot.api.send_message(chat_id: message.chat.id, text: NO_HISTORIAL_DE_TURNOS_MSG.to_s)
    end
  end

  on_message_pattern %r{/cancelar_turno (?<turno_id>\d+)} do |bot, message, args|
    @sistema.cancelar_turno(args['turno_id'], message.from.username)
    bot.api.send_message(chat_id: message.chat.id, text: TURNO_CANCELADO_EXITO_MSG)
  rescue TurnoError => _e
    bot.api.send_message(chat_id: message.chat.id, text: TURNO_CANCELADO_ERROR_MSG)
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: ROUTE_NO_ENCONTRADA_MSG.to_s)
  end
end
