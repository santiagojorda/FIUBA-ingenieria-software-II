#language: es

Característica: Disponibilidad de turnos médicos en días feriados

  Escenario: Médico NO trabaja feriados y se consulta en feriado
    Dado que soy un paciente
    Y existe un médico que NO trabaja los feriados
    Cuando consulto la disponibilidad de ese médico para un día que es feriado y hábil
    Entonces NO se ofrecerá turnos para ese día feriado con ese médico.

  Escenario: Médico SÍ trabaja feriados y se consulta en feriado
    Dado que soy un paciente
    Y existe un médico que SI trabaja los feriados
    Cuando consulto la disponibilidad de ese médico para un día que es feriado y hábil
    Entonces SI se ofrecerá turnos para ese día feriado con ese médico.
