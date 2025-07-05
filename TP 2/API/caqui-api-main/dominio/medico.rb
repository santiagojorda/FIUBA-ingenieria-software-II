class Medico
  attr_reader :nombre, :especialidad, :matricula, :trabaja_feriados, :created_on, :updated_on
  attr_accessor :id

  def initialize(nombre, especialidad, matricula, trabaja_feriados, id: nil)
    @id = id
    @nombre = nombre
    @especialidad = especialidad
    @matricula = matricula
    @trabaja_feriados = trabaja_feriados
  end

  def tiempo_atencion
    @especialidad.tiempo_atencion
  end
end
