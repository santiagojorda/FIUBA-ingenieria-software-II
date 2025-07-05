require_relative './abstract_repository'

class RepositorioEspecialidades < AbstractRepository
  self.table_name = :especialidades
  self.model_class = 'Especialidad'

  def buscar_por_nombre(nombre)
    row = dataset.first(nombre:)
    load_object(row) unless row.nil?
  end

  protected

  def load_object(a_hash)
    Especialidad.new(
      a_hash[:nombre],
      a_hash[:tiempo_atencion],
      a_hash[:id]
    )
  end

  def changeset(especialidad)
    {
      nombre: especialidad.nombre,
      tiempo_atencion: especialidad.tiempo_atencion,
      created_on: especialidad.created_on,
      updated_on: especialidad.updated_on
    }
  end
end
