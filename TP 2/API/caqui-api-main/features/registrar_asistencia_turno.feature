# language: es
@registro_asistencia

Característica: Registro de asistencia de pacientes a sus turnos

  Antecedentes:
    Dado que el paciente está registrado
    Y exite un medico con una especialidad registrada

  Escenario: Registrar asistencia de un paciente a su turno
    Cuando existe un turno para el paciente con el medico
    Y el personal envía la solicitud con el id_turno de ese turno para registrar su asistencia
    Entonces el sistema marca el turno como asistido
    Y se guarda el registro de la asistencia correctamente
