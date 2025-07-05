require_relative '../errores/persistencia/turno_superpuesto_error'

class Sistema
  attr_accessor :proveedor_fecha, :proveedor_feriados

  class Builder
    def initialize
      @repositorios = {}
      @proveedor_fecha = nil
      @proveedor_feriados = nil
      @gestor_pacientes = nil
      @gestor_especialidades = nil
      @gestor_medicos = nil
      @gestor_turnos = nil
    end

    def con_repositorio_pacientes(repo)
      @repositorios[:pacientes] = repo
      self
    end

    def con_repositorio_reputaciones(repo)
      @repositorios[:reputaciones] = repo
      self
    end

    def con_repositorio_medicos(repo)
      @repositorios[:medicos] = repo
      self
    end

    def con_repositorio_especialidades(repo)
      @repositorios[:especialidades] = repo
      self
    end

    def con_repositorio_turnos(repo)
      @repositorios[:turnos] = repo
      self
    end

    def con_proveedor_fecha(proveedor_fecha)
      @proveedor_fecha = proveedor_fecha
      self
    end

    def con_proveedor_feriados(proveedor_feriados)
      @proveedor_feriados = proveedor_feriados
      self
    end

    def build
      validar_builder
      sistema = Sistema.send(:new)
      sistema.instance_variable_set(:@repositorio_especialidades, @repositorios[:especialidades])
      sistema.instance_variable_set(:@repositorio_medicos, @repositorios[:medicos])
      sistema.instance_variable_set(:@repositorio_pacientes, @repositorios[:pacientes])
      sistema.instance_variable_set(:@repositorio_turnos, @repositorios[:turnos])
      sistema.instance_variable_set(:@repositorio_reputaciones, @repositorios[:reputaciones])
      sistema.instance_variable_set(:@proveedor_fecha, @proveedor_fecha)
      sistema.instance_variable_set(:@proveedor_feriados, @proveedor_feriados)
      build_gestores(sistema)
      sistema
    end

    private

    def validar_builder
      unless @repositorios[:pacientes] && @repositorios[:medicos] &&
             @repositorios[:especialidades] && @repositorios[:turnos] && @repositorios[:reputaciones]
        raise ArgumentError, 'Faltan uno o más repositorios para construir el Sistema.'
      end

      raise ArgumentError, 'Falta un proveedor de fecha para construir el Sistema.' unless @proveedor_fecha

      raise ArgumentError, 'Falta un proveedor de feriados para construir el Sistema.' unless @proveedor_feriados
    end

    def build_gestores(sistema)
      sistema.instance_variable_set(:@gestor_pacientes, GestorPacientes.new(@repositorios[:pacientes]))
      sistema.instance_variable_set(:@gestor_especialidades, GestorEspecialidades.new(@repositorios[:especialidades]))
      sistema.instance_variable_set(:@gestor_medicos, GestorMedicos.new(@repositorios[:medicos], @repositorios[:especialidades]))
      sistema.instance_variable_set(:@gestor_turnos, GestorTurnos.new(@repositorios[:turnos], @repositorios[:medicos], @repositorios[:pacientes]))
    end
  end

  private_class_method :new

  def crear_paciente(nombre, dni, email, username)
    paciente = @gestor_pacientes.crear_paciente(nombre, dni, email, username)
    @repositorio_reputaciones.save(Reputacion.new(paciente.id, 0, 0, 0))
    paciente
  end

  def crear_especialidad(nombre, duracion)
    @gestor_especialidades.crear_especialidad(nombre, duracion)
  end

  def crear_medico(nombre, especialidad_str, matricula, trabaja_feriados)
    @gestor_medicos.crear_medico(nombre, especialidad_str, matricula, trabaja_feriados)
  end

  def turnos_disponibles(id_medico, inicio, fin)
    @gestor_turnos.turnos_disponibles(id_medico, inicio, fin, @proveedor_fecha.ahora, @proveedor_feriados)
  end

  def buscar_medico_por_id(id_medico)
    @gestor_medicos.buscar_por_id(id_medico)
  end

  def reservar_turno(id_medico, username, fecha)
    @gestor_turnos.reservar_turno(id_medico, username, fecha)
  end

  def consultar_historial_turnos(username_paciente)
    @gestor_turnos.consultar_historial_turnos(username_paciente, @proveedor_fecha)
  end

  def confirmar_asistencia_turno(id_turno)
    @gestor_turnos.confirmar_asistencia_turno(id_turno, @proveedor_fecha)
  end

  def confirmar_ausencia_turno(id_turno)
    @gestor_turnos.confirmar_ausencia_turno(id_turno, @proveedor_fecha)
  end

  def buscar_turnos_pendientes_por_paciente(username_paciente, inicio, fin)
    @gestor_turnos.buscar_turnos_pendientes_por_paciente(username_paciente, inicio, fin)
  end

  def buscar_turnos_asignados_por_medico(medico_id)
    @gestor_turnos.buscar_turnos_asignados_por_medico(medico_id)
  end

  def consultar_reputacion(username)
    paciente = @repositorio_pacientes.buscar_por_usuario_telegram(username)
    reputacion = @repositorio_reputaciones.buscar_por_paciente_id(paciente.id)
    reputacion.calcular_penalizacion
  end

  def aumentar_asistencias(id_turno)
    turno = @repositorio_turnos.find(id_turno)
    paciente = turno.paciente
    @repositorio_reputaciones.aumentar_asistencias(paciente.id)
  end

  def aumentar_inasistencias(id_turno)
    turno = @repositorio_turnos.find(id_turno)
    paciente = turno.paciente
    @repositorio_reputaciones.aumentar_inasistencias(paciente.id)
  end

  def aumentar_cancelaciones(id_turno)
    turno = @repositorio_turnos.find(id_turno)
    paciente = turno.paciente
    @repositorio_reputaciones.aumentar_cancelaciones(paciente.id)
  end

  def cancelar_turno(id_turno)
    turno = @repositorio_turnos.find(id_turno)
    turno.cancelar(@proveedor_fecha)
    @repositorio_turnos.save(turno)

    if cancelacion_con_mas_de_24_horas_de_anticipacion?(turno)
      'Turno cancelado.'
    else
      'Turno cancelado. Se considera inasistencia.'
    end
  end

  private

  attr_accessor :repositorio_especialidades, :repositorio_medicos, :repositorio_pacientes, :repositorio_turnos, :repositorio_reputaciones

  def cancelacion_con_mas_de_24_horas_de_anticipacion?(turno)
    @proveedor_fecha.ahora.diferencia_en_horas(turno.fecha) > 24.0
  end
end
