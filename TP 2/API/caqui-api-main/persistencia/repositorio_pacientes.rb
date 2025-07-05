require_relative './abstract_repository'

class RepositorioPacientes < AbstractRepository
  self.table_name = :pacientes
  self.model_class = 'Paciente'

  def buscar_por_dni(dni)
    row = dataset.first(dni:)
    raise ArgumentError, "No se encontró un paciente con el DNI: #{dni}" if row.nil?

    load_object(row)
  end

  def buscar_por_usuario_telegram(telegram_username)
    row = dataset.first(telegram_username:)
    raise ArgumentError, "No se encontró un paciente con el usuario de Telegram: #{telegram_username}" if row.nil?

    load_object(row)
  end

  protected

  def load_object(a_hash)
    Paciente.new(a_hash[:nombre], a_hash[:dni], a_hash[:email], a_hash[:id], a_hash[:telegram_username])
  end

  def changeset(paciente)
    {
      nombre: paciente.nombre,
      dni: paciente.dni,
      email: paciente.email,
      telegram_username: paciente.username
    }
  end
end
