# language: es

@consulta_turnos 

Característica: Consulta de historial de turnos por el paciente

  Escenario: Paciente consulta su historial con más de 5 turnos pasados
    Dado que soy paciente
    Y dado que tengo "5" turnos que reservo y que ya han pasado
    Cuando solicito ver mi historial de turnos anteriores
    Entonces se muestra una lista con mis "5" últimos turnos, ordenados del más reciente al más antiguo

  Escenario: Paciente consulta su historial con menos de 5 turnos pasados
    Dado que soy paciente
    Y dado que tengo "2" turnos que reservo y que ya han pasado
    Cuando solicito ver mi historial de turnos anteriores
    Entonces se muestra una lista con mis "2" últimos turnos, ordenados del más reciente al más antiguo

  Escenario: Paciente consulta su historial sin turnos pasados
    Dado que soy paciente
    Y no tengo turnos anteriores en mi historial
    Cuando solicito ver mi historial de turnos anteriores
    Entonces el historial de turnos esta vacio