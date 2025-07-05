class RepositorioReputaciones < AbstractRepository
  self.table_name = :reputaciones
  self.model_class = 'Reputacion'

  def buscar_por_id(id)
    row = dataset.first(id:)
    raise ArgumentError, "No se encontró una reputación con el ID: #{id}" if row.nil?

    load_object(row)
  end

  def buscar_por_paciente_id(id_paciente)
    row = dataset.first(id_paciente:)
    raise ArgumentError, "No se encontró una reputación para el paciente con ID: #{id_paciente}" if row.nil?

    load_object(row)
  end

  def load_object(a_hash)
    Reputacion.new(a_hash[:id_paciente], a_hash[:inasistencias], a_hash[:asistencias], a_hash[:cancelaciones])
  end

  def aumentar_asistencias(id_paciente)
    dataset.where(id_paciente:).update(asistencias: Sequel[:asistencias] + 1)
  end

  def aumentar_inasistencias(id_paciente)
    dataset.where(id_paciente:).update(inasistencias: Sequel[:inasistencias] + 1)
  end

  def aumentar_cancelaciones(id_paciente)
    dataset.where(id_paciente:).update(cancelaciones: Sequel[:cancelaciones] + 1)
  end

  protected

  def changeset(reputacion)
    {
      id_paciente: reputacion.id_paciente,
      inasistencias: reputacion.inasistencias,
      asistencias: reputacion.asistencias,
      cancelaciones: reputacion.cancelaciones,
      penalizacion: reputacion.penalizacion
    }
  end
end
