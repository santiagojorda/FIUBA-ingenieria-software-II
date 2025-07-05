require_relative 'paciente'
require_relative 'turno'
require_relative 'medico'
require_relative 'excepciones/objeto_no_encontrado_exception'
require_relative 'excepciones/registracion_exception'
require_relative 'excepciones/turno_exception'
class Sistema
  def initialize(conector)
    @conector = conector
  end

  def registrar_nuevo_paciente(nombre, dni, mail, usuario)
    paciente = Paciente.new(nombre, dni, mail, usuario)
    @conector.registrar_paciente(paciente)
  end

  def buscar_turnos_por_medico(id_medico, inicio, fin)
    medico = @conector.obtener_medico(id_medico)
    @conector.obtener_turnos_por_medico(medico, inicio, fin)
  end

  def reservar_turnos_por_medico(id_medico, fecha, usuario)
    medico = @conector.obtener_medico(id_medico)
    @conector.reservar_turno(medico, fecha, usuario)
  end

  def obtener_turnos_pendientes(username)
    @conector.obtener_turnos_pendientes(username)
  end

  def obtener_historial_turnos(username)
    @conector.obtener_historial_turnos(username)
  end

  def cancelar_turno(turno_id, usuario)
    @conector.cancelar_turno(turno_id, usuario)
  end
end
