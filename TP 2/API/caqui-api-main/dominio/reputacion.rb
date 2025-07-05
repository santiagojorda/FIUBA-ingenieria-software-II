class Reputacion
  attr_reader :id_paciente, :inasistencias, :asistencias, :cancelaciones, :penalizacion, :updated_on, :created_on
  attr_accessor :id

  def initialize(id_paciente, inasistencias, asistencias, cancelaciones)
    @id = nil
    @id_paciente = id_paciente
    @inasistencias = inasistencias
    @asistencias = asistencias
    @cancelaciones = cancelaciones
    @penalizacion = calcular_penalizacion
  end

  def calcular_penalizacion
    porcentaje_inasitencias = inasistencias.to_f / (asistencias + inasistencias + cancelaciones)
    @penalizacion = if porcentaje_inasitencias >= 0.1
                      -1
                    else
                      0
                    end
  end
end
