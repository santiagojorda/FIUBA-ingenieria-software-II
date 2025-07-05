# language: es
@reservar_turnos

Característica: Reserva de turno
  Antecedentes:
    Dado que el paciente está registrado

  Escenario: Reserva exitosa de un turno
    Cuando el paciente reserva el '08/10' a las '10:00' con un medico especifico
    Entonces muestra una reserva exitosa
