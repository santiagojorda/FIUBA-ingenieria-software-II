# language: es
@busqueda_turnos

Característica: Búsqueda de turnos por médico

  Antecedentes:
    Dado que el paciente está registrado
    Y existen especilidades medicas registradas

  Escenario: Buscar turnos disponibles para un médico
    Cuando el paciente pide un turno con un medico especifico
    Entonces el sistema muestra los turnos disponibles
    Y los turnos están ordenados desde el más próximo al más lejano
    Y los turnos no superan los 60 días desde la fecha actual
    Y los turnos comienzan a partir del día siguiente a la consulta

  Escenario: Buscar turnos para un traumatólogo con duración de turno estándar
    Cuando el paciente pide un turno para "traumatologia"
    Entonces el sistema muestra los turnos disponibles
    Y cada turno tiene una duración de "30" minutos

  Escenario: Buscar turnos para un odontólogo con duración de turno mayor
    Cuando el paciente pide un turno para "odontologia"
    Entonces el sistema muestra los turnos disponibles
    Y cada turno tiene una duración de "40" minutos
