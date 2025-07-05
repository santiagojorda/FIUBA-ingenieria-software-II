require 'dotenv'
require 'semantic_logger'
require 'uri'
require_relative '../model/paciente'
require_relative '../model/medico'
require_relative '../model/excepciones/objeto_no_encontrado_exception'
require_relative '../model/excepciones/registracion_exception'
require_relative '../model/excepciones/turno_exception'
require_relative '../model/excepciones/usuario_penalizado'

Dotenv.load('.env')
class ConectorAPI
  def initialize(logger)
    @logger = logger
  end

  def obtener_version_api
    url = "#{ENV['URL_API']}/version"
    status, body = get(url)
    raise "HTTP #{status}" if status != 200

    body['version']
  end

  def registrar_paciente(paciente)
    nombre = paciente.nombre
    dni = paciente.dni
    mail = paciente.mail
    usuario = paciente.usuario
    url = "#{ENV['URL_API']}/paciente"
    status, _body = post(url, { nombre:, dni:, email: mail, username: usuario }.to_json)
    raise ErrorDeRegistracion, 'medico no encontrado' if status != 201
  end

  def obtener_medico(id_medico)
    url = "#{ENV['URL_API']}/medicos/#{id_medico}"
    status, body = get(url)
    raise ObjetoNoEncontrado, 'medico no encontrado' if status != 200

    Medico.new(body['nombre'], body['especialidad'], id_medico)
  end

  def obtener_turnos_por_medico(medico, inicio, fin)
    url = "#{ENV['URL_API']}/turnos/#{medico.id}/#{inicio}/#{fin}"
    status, body = get(url)
    raise ObjetoNoEncontrado, 'turnos no encontrados por medico' if status != 200

    body.map do |t|
      Turno.new(medico, t['fecha'])
    end
  end

  def reservar_turno(medico, fecha, usuario)
    url = "#{ENV['URL_API']}/reservar"
    status, _body = post(url, { id_medico: medico.id, username: usuario, fecha: }.to_json)
    raise UsuarioPen, 'El usuario está penalizado y solo puede tener un turno pendiente a la vez' if status == 408
    raise TurnoError, "error al reservar el turno con medico id:#{medico.id} el dia #{fecha}" if status != 201
  end

  def obtener_turnos_pendientes(username)
    url = "#{ENV['URL_API']}/turnos_pendientes/#{username}/0/10"
    status, body = get(url)
    return [] if status != 200

    vector_de_turnos = []
    body.map do |t|
      turno = Turno.new(
        Medico.new(t['nombre_medico'], t['especialidad']), t['fecha'], nil, t['id_turno']
      )
      vector_de_turnos << turno
    end
    vector_de_turnos
  end

  def obtener_historial_turnos(username)
    url = "#{ENV['URL_API']}/historial_turnos/#{username}"
    status, body = get(url)
    return [] if status != 200

    body.map do |t|
      Turno.new(
        Medico.new(t['nombre_medico'], t['especialidad']),
        t['fecha'],
        nil,
        t['id'],
        t['estado']
      )
    end
  end

  def cancelar_turno(turno_id, usuario)
    url = "#{ENV['URL_API']}/turnos/#{turno_id}/cancelar"
    status, _body = post(url, { usuario: }.to_json)
    raise TurnoError, 'error al cancelar el turno' if status != 200
  end

  private

  def post(url, body_to_post)
    correlation_id = Thread.current[:cid]
    respuesta = Faraday.post(url, body_to_post, { 'Content-Type' => 'application/json', 'cid' => correlation_id, 'Authorization' => ENV['AUTH_TOKEN'] })
    @logger.info "POST #{url}, body: #{body_to_post}, status: #{respuesta.status}"
    begin
      body_parseado = JSON.parse(respuesta.body)
    rescue JSON::ParserError => _e
      return [respuesta.status, {}]
    end
    [respuesta.status, body_parseado]
  end

  def get(url)
    correlation_id = Thread.current[:cid]
    respuesta = Faraday.get(url, nil, { 'Content-Type' => 'application/json', 'cid' => correlation_id, 'Authorization' => ENV['AUTH_TOKEN'] })
    @logger.info "GET #{url}, status: #{respuesta.status}"
    begin
      _body = JSON.parse(respuesta.body)
    rescue JSON::ParserError => _e
      return [respuesta.status, {}]
    end
    [respuesta.status, JSON.parse(respuesta.body)]
  end
end
