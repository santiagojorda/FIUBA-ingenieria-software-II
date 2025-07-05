# language: es

@registracion_paciente

Característica: T.2 tecnico: seguridad auth

Escenario: T.2: al registrarme sin token, no tengo que poder
  Dado que no estoy autenticado
  Cuando quiero registrarme
  Entonces obtengo un error por no estar autorizado.

