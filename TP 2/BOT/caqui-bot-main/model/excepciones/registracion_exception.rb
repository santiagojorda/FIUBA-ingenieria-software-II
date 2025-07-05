class ErrorDeRegistracion < StandardError
  def initialize(msg = 'No se pudo registrar')
    super
  end
end
