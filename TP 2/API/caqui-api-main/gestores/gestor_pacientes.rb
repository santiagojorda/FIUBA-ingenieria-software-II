class GestorPacientes
  def initialize(repositorio_pacientes)
    @repositorio_pacientes = repositorio_pacientes
  end

  def crear_paciente(nombre, dni, email, username)
    paciente = Paciente.new(nombre, dni, email, nil, username)
    @repositorio_pacientes.save(paciente)
    paciente
  end
end
