# language: es
@registro_inasistencia

Característica: Registro de inasistencias por personal del hospital

  Escenario: Registrar inasistencia para un turno cuya fecha y hora ya pasó
    Dado que existe un turno agendado para un paciente el dia "16/05/2025 08:30"
    Y la fecha y hora de dicho turno ya han transcurrido
    Cuando intento registrar la inasistencia para ese turno
    Entonces el sistema permite registrar la inasistencia
    Y la inasistencia queda registrada para ese turno.

  Escenario: Intentar registrar inasistencia para un turno cuya fecha y hora aún no ha pasado
    Dado que existe un turno agendado para un paciente el dia "16/12/2025 08:30"
    Cuando intento registrar la inasistencia para ese turno
    Entonces el sistema no me permite registrar la inasistencia
