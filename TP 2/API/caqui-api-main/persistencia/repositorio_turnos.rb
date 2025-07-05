require_relative './abstract_repository'

class RepositorioTurnos < AbstractRepository
  self.table_name = :turnos
  self.model_class = 'Turno'

  def buscar_superposiciones(turno)
    dataset.where(
      medico_id: turno.medico.id,
      fecha: turno.fecha.to_datetime
    ).map { |row| load_object(row) }
  end

  def buscar_pendientes_por_paciente(paciente)
    dataset.where(
      paciente_id: paciente.id,
      estado: EstadoTurnoID::PENDIENTE
    )
           .order(:fecha)
           .map { |r| load_object(r) }
  end

  def buscar_turnos_paciente(paciente)
    dataset.where(paciente_id: paciente.id)
           .order(Sequel.desc(:fecha))
           .map { |r| load_object(r) }
  end

  def buscar_turnos_pasados(paciente, proveedor_fecha)
    dataset
      .where(paciente_id: paciente.id)
      .where { fecha < proveedor_fecha.ahora.to_datetime }
      .order(Sequel.desc(:fecha))
      .map { |r| load_object(r) }
  end

  def buscar_asignados_por_medico(medico)
    dataset.where(medico_id: medico.id,
                  estado: EstadoTurnoID::PENDIENTE)
           .order(:fecha)
           .map { |r| load_object(r) }
  end

  protected

  def load_object(a_hash)
    medico = RepositorioMedicos.new.find(a_hash[:medico_id])
    paciente = RepositorioPacientes.new.find(a_hash[:paciente_id])
    estado = EstadoTurnoFactory.crear(a_hash[:estado].to_i)
    fecha = FechaHorario.new(a_hash[:fecha])
    Turno.new(medico, paciente, fecha, estado:, id: a_hash[:id])
  end

  def changeset(turno)
    {
      medico_id: turno.medico.id,
      paciente_id: turno.paciente.id,
      fecha: turno.fecha.to_datetime,
      estado: turno.estado.id
    }
  end
end
