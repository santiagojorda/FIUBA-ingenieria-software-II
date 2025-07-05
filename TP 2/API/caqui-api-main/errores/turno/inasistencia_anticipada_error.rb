class InasistenciaAnticipadaError < StandardError
  def initialize
    super('turno_no_pasado_error')
  end
end
