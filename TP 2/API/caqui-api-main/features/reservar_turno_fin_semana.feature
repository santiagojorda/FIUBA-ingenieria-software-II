# language: es
@reservar_turnos_finde
Característica: Búsqueda de turnos para la semana siguiente

  Escenario: Paciente busca turnos un viernes y hay disponibilidad el lunes
    Dado hoy es viernes
    Y que soy un paciente
    Y existe un medico con turnos disponibles el día lunes
    Cuando paciente busca turnos para el medico
    Entonces se me ofrecerá turnos a partir del lunes.

  Escenario: Paciente busca turnos un miercoles y hay disponibilidad el lunes
    Dado hoy es miercoles
    Y que soy un paciente
    Y existe un medico con turnos disponibles el día lunes
    Cuando paciente busca turnos para el medico
    Entonces se me ofrecerá turnos a partir del lunes.
