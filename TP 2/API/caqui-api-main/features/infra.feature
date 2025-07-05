# language: es
@infra 
Característica: Infraestructura

Escenario: infra-1: endpoint /version incluye la version
  Cuando pido get version
  Entonces obtengo la version de la api
  Y la respuesta es de tipo json
