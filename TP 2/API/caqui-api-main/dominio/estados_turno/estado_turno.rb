class EstadoTurno
  attr_reader :id

  def initialize(id, turno_str)
    @id = id
    @turno_str = turno_str
  end

  def to_s
    @turno_str
  end
end
