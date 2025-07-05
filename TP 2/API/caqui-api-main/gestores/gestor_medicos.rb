class GestorMedicos
  def initialize(repositorio_medicos, repositorio_especialidades)
    @repositorio_medicos = repositorio_medicos
    @repositorio_especialidades = repositorio_especialidades
  end

  def crear_medico(nombre, especialidad_str, matricula, trabaja_feriados)
    especialidad = @repositorio_especialidades.buscar_por_nombre(especialidad_str)

    medico = Medico.new(nombre, especialidad, matricula, trabaja_feriados)
    @repositorio_medicos.save(medico)
    medico
  end

  def buscar_por_id(id_medico)
    @repositorio_medicos.buscar_por_id(id_medico)
  end
end
