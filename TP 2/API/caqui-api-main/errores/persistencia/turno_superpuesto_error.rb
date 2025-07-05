class TurnoSuperpuestoError < StandardError
  def initialize
    super('turno_superpuesto')
  end
end
