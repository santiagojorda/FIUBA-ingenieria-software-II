class GestorEspecialidades
  def initialize(repositorio_especialidades)
    @repositorio_especialidades = repositorio_especialidades
  end

  def crear_especialidad(nombre, tiempo_atencion)
    especialidad = Especialidad.new(nombre, tiempo_atencion, nil)
    @repositorio_especialidades.save(especialidad)
    especialidad
  end

  def buscar_por_nombre(nombre)
    @repositorio_especialidades.buscar_por_nombre(nombre)
  end
end
