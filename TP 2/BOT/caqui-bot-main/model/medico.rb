class Medico
  attr_reader :nombre, :especialidad
  attr_accessor :id

  def initialize(nombre, especialidad, id = nil)
    @nombre = nombre
    @especialidad = especialidad
    @id = id
  end

  def info_s
    "#{@nombre} - #{@especialidad}"
  end
end
