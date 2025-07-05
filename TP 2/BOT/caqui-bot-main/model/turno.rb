class Turno
  attr_reader :medico, :horario
  attr_accessor :id_turno, :paciente, :estado

  def initialize(medico, horario, paciente = nil, id_turno = nil, estado = nil)
    @id_turno = id_turno
    @medico = medico
    @horario = horario
    @paciente = paciente
    @estado = estado || 'pendiente'
  end

  def callbacks_pedir_turno
    "turno_#{@horario}_medico_#{@medico.id}_nombre_#{@medico.nombre}"
  end

  def resumen_pendiente
    fecha = Time.parse(@horario).strftime('%d/%m/%Y %H:%M')
    "- ID: #{@id_turno}\n- Fecha: #{fecha} \n- Médico: #{@medico.nombre} \n- Especialidad: #{@medico.especialidad}"
  end

  def resumen_historial
    "- ID: #{@id_turno}\n- Fecha: #{@horario}\n- Especialidad: #{@medico.especialidad}\n- Médico: #{@medico.nombre}\n- Estado: #{@estado}"
  end
end
