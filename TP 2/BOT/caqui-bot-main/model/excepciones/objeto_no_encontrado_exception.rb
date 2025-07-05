class ObjetoNoEncontrado < StandardError
  def initialize(msg = 'Objeto no encontrado')
    super
  end
end
