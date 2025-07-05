class Especialidad
  attr_reader :nombre, :tiempo_atencion, :created_on, :updated_on
  attr_accessor :id

  def initialize(nombre, tiempo_atencion, id = nil)
    @id = id
    @nombre = nombre
    @tiempo_atencion = tiempo_atencion
  end
end
