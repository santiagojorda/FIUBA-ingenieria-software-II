# language: es
@registracion_paciente

Característica: P.1.1 Registro de paciente desde Telegram

Escenario: 1.1 Registro exitoso con los datos requeridos
Dado que el paciente ingresa el nombre "nombre", el dni "dni" y el mail "mail"
Cuando se registra
Entonces el sistema registra al paciente de forma exitosa
