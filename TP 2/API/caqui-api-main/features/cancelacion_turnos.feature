# language: es

Característica: Cancelación de turnos por el paciente

  Escenario: Cancelación exitosa con más de 24 horas de anticipación
    Dado que soy un paciente
    Y hoy y mañana son dias habiles, no feriados
    Y tengo un turno pendiente agendado para mañana dentro de más de 24 horas
    Cuando cancelo dicho turno
    Entonces el turno se registra como cancelado
    Y se notifica al paciente con el mensaje: "Turno cancelado."
    Y el horario del turno SI queda disponible.

  Escenario: Cancelación con menos de 24 horas de anticipación el dia anterior
    Dado que soy un paciente
    Y hoy y mañana son dias habiles, no feriados
    Y tengo un turno pendiente agendado para mañana dentro de menos de 24 horas
    Cuando cancelo dicho turno
    Entonces el turno se registra como cancelado
    Y se notifica al paciente con el mensaje: "Turno cancelado. Se considera inasistencia."
    Y el horario del turno SI queda disponible.

  Escenario: Cancelación el mismo dia del turno
    Dado que soy un paciente
    Y hoy es un dia habil y no es feriado
    Y tengo un turno pendiente agendado para el mismo dia
    Cuando cancelo dicho turno
    Entonces el turno se registra como cancelado
    Y se notifica al paciente con el mensaje: "Turno cancelado. Se considera inasistencia."
    Y el horario del turno NO queda disponible.

  Escenario: Intento de cancelación de un turno que ya pasó
    Dado que soy un paciente
    Y hoy es un dia habil y no es feriado
    Y tengo un turno agendado para hoy pero este ya pasó
    Cuando cancelo dicho turno
    Entonces el sistema no permite la cancelación del turno.
