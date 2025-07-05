# language: es

@consulta_turnos_medicos

Característica: Consulta de turnos asignados
  Escenario: Medico con turnos asignados
    Dado que existe un medico
    Y ese medico tiene "2" turnos reservados
    Cuando se consulta los turnos pendientes del medico
    Entonces se muestra una lista con id_turno, fecha, hora, nombre de paciente

  Escenario: Medico sin turnos asignados
  Dado que existe un medico
  Y ese medico no tiene turnos reservados
  Cuando se consulta los turnos pendientes del medico
  Entonces se muestra una lista vacia
