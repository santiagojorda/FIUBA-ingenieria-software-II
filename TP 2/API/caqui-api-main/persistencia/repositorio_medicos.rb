require_relative './abstract_repository'

class RepositorioMedicos < AbstractRepository
  self.table_name = :medicos
  self.model_class = 'Medico'

  def buscar_por_matricula(matricula)
    row = dataset.first(matricula: matricula.to_s)
    raise ArgumentError, "No se encontró un médico con la matrícula: #{matricula}" if row.nil?

    load_object(row)
  end

  def buscar_por_id(id)
    row = dataset.first(id: id.to_i)
    raise ArgumentError, "No se encontró un médico con el ID: #{id}" if row.nil?

    load_object(row)
  end

  protected

  def load_object(a_record)
    especialidad_id = a_record[:especialidad_id]
    especialidad = RepositorioEspecialidades.new.find(especialidad_id)

    medico = Medico.new(a_record[:nombre], especialidad, a_record[:matricula], a_record[:trabaja_feriados])
    medico.id = a_record[:id]
    medico
  end

  def changeset(medico)
    {
      nombre: medico.nombre,
      matricula: medico.matricula,
      especialidad_id: RepositorioEspecialidades.new.buscar_por_nombre(medico.especialidad.nombre).id,
      trabaja_feriados: medico.trabaja_feriados
    }
  end
end
