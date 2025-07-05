class UsuarioPen < StandardError
  def initialize(msg = 'El usuario está penalizado y solo puede tener un turno pendiente a la vez')
    super
  end
end
