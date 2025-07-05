class Paciente
  attr_reader :nombre, :dni, :email, :updated_on, :created_on, :username
  attr_accessor :id

  def initialize(nombre, dni, email, id = nil, username)
    @id = id
    @nombre = nombre
    @dni = dni
    @email = email
    @username = username
  end
end
