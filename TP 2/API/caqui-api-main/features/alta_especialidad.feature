# language: es

@alta_especialidad

Característica: Alta de nuevas especialidades médicas

  Escenario: Alta exitosa de especialidad
    Cuando envía una solicitud para crear una especialidad con nombre "Cardiologia" y duración de "30" minutos
    Entonces el sistema crea la especialidad
    Y adjunta el id de la especialidad creada
