# language: es

@consulta_turnos

Característica: Consulta de turnos pendientes 

  Escenario: Consultar turnos pendientes con resultados
    Dado que el paciente 'pepe' está registrado
    Y que el paciente 'pepe' tiene turnos reservados
    Cuando el paciente consulta los turnos pendientes
    Entonces el sistema muestra una lista con id_turno, fecha, hora, especialidad y nombre_medico

  Escenario: Consultar turnos pendientes sin resultados
    Dado que el paciente 'lu' está registrado
    Y que el paciente 'lu' no tiene turnos reservados
    Cuando el paciente consulta los turnos pendientes
    Entonces el sistema muestra que no hay turnos
