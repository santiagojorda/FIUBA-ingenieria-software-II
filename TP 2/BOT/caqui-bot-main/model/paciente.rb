class Paciente
  attr_reader :nombre, :dni, :mail, :usuario

  def initialize(nombre, dni, mail, usuario)
    @nombre = nombre
    @dni = dni
    @mail = mail
    @usuario = usuario
  end
end
