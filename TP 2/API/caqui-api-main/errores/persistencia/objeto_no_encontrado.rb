class ObjetoNoEncontrado < StandardError
  def initialize(model_class, id)
    super("No se encontró objeto de la clase #{model_class} con id=#{id}")
  end
end
