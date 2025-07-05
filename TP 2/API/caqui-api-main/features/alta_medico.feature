# language: es

@alta_medico

Característica: Alta de nuevos médicos

  Escenario: Alta exitosa de un médico
    Cuando registro un medico con la informacion: 'juan porto' como nombre 'traumatologo' como especialidad '99999' como matricula y 'false' para trabaja feriados
    Entonces se registro exitosamente
    Y el medico tiene un id asignado
