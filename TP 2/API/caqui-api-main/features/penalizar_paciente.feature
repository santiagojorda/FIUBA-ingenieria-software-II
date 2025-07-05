# language: es
@infra
Característica: Penalizar pacientes

Antecedentes:
    Dado que el paciente "pepe" está registrado
    Y existen especilidades medicas registradas

Escenario: Paciente alcanza el 10% o más de inasistencias
Dado que un paciente tiene 10 turnos en su historial
Y tiene 1 inasistencia y 9 asistencias
Cuando el paciente intenta sacar mas de un turno
Entonces solo se le permite un turno pendiente

Escenario: Paciente pasa de estar penalizado a no estar penalizado al mejorar su reputacion.
Dado que un paciente tiene 10 turnos en su historial
Y tiene 1 inasistencia y 9 asistencias
Y el paciente reserva un turno nuevo y asiste al mismo
Entonces el paciente deja de estar penalizado
                